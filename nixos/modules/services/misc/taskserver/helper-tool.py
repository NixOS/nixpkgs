import grp
import pwd
import os
import re
import string
import subprocess
import sys

from shutil import rmtree
from tempfile import NamedTemporaryFile

import click

CERTTOOL_COMMAND = "@certtool@"
TASKD_COMMAND = "@taskd@"
TASKD_DATA_DIR = "@dataDir@"
TASKD_USER = "@user@"
TASKD_GROUP = "@group@"
FQDN = "@fqdn@"

RE_CONFIGUSER = re.compile(r'^\s*user\s*=(.*)$')


def run_as_taskd_user():
    uid = pwd.getpwnam(TASKD_USER).pw_uid
    gid = grp.getgrnam(TASKD_GROUP).gr_gid
    os.setgid(gid)
    os.setuid(uid)


def taskd_cmd(cmd, *args, **kwargs):
    return subprocess.call(
        [TASKD_COMMAND, cmd, "--data", TASKD_DATA_DIR] + list(args),
        preexec_fn=run_as_taskd_user,
        **kwargs
    )


def label(msg):
    if sys.stdout.isatty() or sys.stderr.isatty():
        sys.stderr.write(msg + "\n")


def mkpath(*args):
    return os.path.join(TASKD_DATA_DIR, "orgs", *args)


def fetch_username(org, key):
    for line in open(mkpath(org, "users", key, "config"), "r"):
        match = RE_CONFIGUSER.match(line)
        if match is None:
            continue
        return match.group(1).strip()
    return None


def generate_key(org, user):
    basedir = os.path.join(TASKD_DATA_DIR, "keys", org, user)
    if os.path.exists(basedir):
        raise OSError("Keyfile directory for {} already exists.".format(user))

    privkey = os.path.join(basedir, "private.key")
    pubcert = os.path.join(basedir, "public.cert")
    cakey = os.path.join(TASKD_DATA_DIR, "keys", "ca.key")
    cacert = os.path.join(TASKD_DATA_DIR, "keys", "ca.cert")

    try:
        os.makedirs(basedir, mode=0700)

        cmd = [CERTTOOL_COMMAND, "-p", "--bits", "2048", "--outfile", privkey]
        subprocess.call(cmd, preexec_fn=lambda: os.umask(0077))

        template = NamedTemporaryFile(mode="w", prefix="certtool-template")
        template.writelines(map(lambda l: l + "\n", [
            "organization = {0}".format(org),
            "cn = {}".format(FQDN),
            "tls_www_client",
            "encryption_key",
            "signing_key"
        ]))
        template.flush()

        cmd = [CERTTOOL_COMMAND, "-c",
               "--load-privkey", privkey,
               "--load-ca-privkey", cakey,
               "--load-ca-certificate", cacert,
               "--template", template.name,
               "--outfile", pubcert]
        subprocess.call(cmd, preexec_fn=lambda: os.umask(0077))
    except:
        rmtree(basedir)
        raise


def is_key_line(line, match):
    return line.startswith("---") and line.lstrip("- ").startswith(match)


def getkey(*args):
    path = os.path.join(TASKD_DATA_DIR, "keys", *args)
    buf = []
    for line in open(path, "r"):
        if len(buf) == 0:
            if is_key_line(line, "BEGIN"):
                buf.append(line)
            continue

        buf.append(line)

        if is_key_line(line, "END"):
            return ''.join(buf)
    raise IOError("Unable to get key from {}.".format(path))


def mktaskkey(cfg, path, keydata):
    heredoc = 'cat > "{}" <<EOF\n{}EOF'.format(path, keydata)
    cmd = 'task config taskd.{} -- "{}"'.format(cfg, path)
    return heredoc + "\n" + cmd


@click.group()
@click.option('--service-helper', is_flag=True)
@click.pass_context
def cli(ctx, service_helper):
    """
    Manage Taskserver users and certificates
    """
    ctx.obj = {'is_service_helper': service_helper}


@cli.command("list-users")
@click.argument("organisation")
def list_users(organisation):
    """
    List all users belonging to the specified organisation.
    """
    label("The following users exist for {}:".format(organisation))
    for key in os.listdir(mkpath(organisation, "users")):
        name = fetch_username(organisation, key)
        if name is not None:
            sys.stdout.write(name + "\n")


@cli.command("list-orgs")
def list_orgs():
    """
    List available organisations
    """
    label("The following organisations exist:")
    for org in os.listdir(mkpath()):
        sys.stdout.write(org + "\n")


@cli.command("get-uuid")
@click.argument("organisation")
@click.argument("user")
def get_uuid(organisation, user):
    """
    Get the UUID of the specified user belonging to the specified organisation.
    """
    for key in os.listdir(mkpath(organisation, "users")):
        name = fetch_username(organisation, key)
        if name is not None and name == user:
            label("User {} has the following UUID:".format(name))
            sys.stdout.write(key + "\n")
            return
    sys.exit("No UUID found for user {}.".format(user))


@cli.command("export-user")
@click.argument("organisation")
@click.argument("user")
def export_user(organisation, user):
    """
    Export user of the specified organisation as a series of shell commands
    that can be used on the client side to easily import the certificates.

    Note that the private key will be exported as well, so use this with care!
    """
    name = key = None
    for current_key in os.listdir(mkpath(organisation, "users")):
        name = fetch_username(organisation, current_key)
        if name is not None and name == user:
            key = current_key
            break

    if name is None:
        msg = "User {} doesn't exist in organisation {}."
        sys.exit(msg.format(user, organisation))

    pubcert = getkey(organisation, user, "public.cert")
    privkey = getkey(organisation, user, "private.key")
    cacert = getkey("ca.cert")

    keydir = "${TASKDATA:-$HOME/.task}/keys"

    credentials = '/'.join([organisation, user, key])
    allow_unquoted = string.ascii_letters + string.digits + "/-_."
    if not all((c in allow_unquoted) for c in credentials):
        credentials = "'" + credentials.replace("'", r"'\''") + "'"

    script = [
        "umask 0077",
        'mkdir -p "{}"'.format(keydir),
        mktaskkey("certificate", os.path.join(keydir, "public.cert"), pubcert),
        mktaskkey("key", os.path.join(keydir, "private.key"), privkey),
        mktaskkey("ca", os.path.join(keydir, "ca.cert"), cacert),
        "task config taskd.credentials -- {}".format(credentials)
    ]

    sys.stdout.write('\n'.join(script))


@cli.command("add-org")
@click.argument("name")
@click.pass_obj
def add_org(obj, name):
    """
    Create an organisation with the specified name.
    """
    if os.path.exists(mkpath(name)):
        if obj['is_service_helper']:
            return
        msg = "Organisation with name {} already exists."
        sys.exit(msg.format(name))

    taskd_cmd("add", "org", name)


@cli.command("add-user")
@click.argument("organisation")
@click.argument("user")
@click.pass_obj
def add_user(obj, organisation, user):
    """
    Create a user for the given organisation along with a client certificate
    and print the key of the new user.

    The client certificate along with it's public key can be shown via the
    'export-user' subcommand.
    """
    if not os.path.exists(mkpath(organisation)):
        sys.exit("Organisation {} does not exist.".format(organisation))

    if os.path.exists(mkpath(organisation, "users")):
        for key in os.listdir(mkpath(organisation, "users")):
            name = fetch_username(organisation, key)
            if name is not None and name == user:
                if obj['is_service_helper']:
                    return
                msg = "User {} already exists in organisation {}."
                sys.exit(msg.format(user, organisation))

    taskd_cmd("add", "user", organisation, user)
    generate_key(organisation, user)


@cli.command("add-group")
@click.argument("organisation")
@click.argument("group")
@click.pass_obj
def add_group(obj, organisation, group):
    """
    Create a group for the given organisation.
    """
    if os.path.exists(mkpath(organisation, "groups", group)):
        if obj['is_service_helper']:
            return
        msg = "Group {} already exists in organisation {}."
        sys.exit(msg.format(group, organisation))

    taskd_cmd("add", "group", organisation, group)


if __name__ == '__main__':
    cli()
