import grp
import json
import pwd
import os
import re
import string
import subprocess
import sys

from contextlib import contextmanager
from shutil import rmtree
from tempfile import NamedTemporaryFile

import click

IS_AUTO_CONFIG = @isAutoConfig@ # NOQA
CERTTOOL_COMMAND = "@certtool@"
CERT_BITS = "@certBits@"
CLIENT_EXPIRATION = "@clientExpiration@"
CRL_EXPIRATION = "@crlExpiration@"

TASKD_COMMAND = "@taskd@"
TASKD_DATA_DIR = "@dataDir@"
TASKD_USER = "@user@"
TASKD_GROUP = "@group@"
FQDN = "@fqdn@"

CA_KEY = os.path.join(TASKD_DATA_DIR, "keys", "ca.key")
CA_CERT = os.path.join(TASKD_DATA_DIR, "keys", "ca.cert")
CRL_FILE = os.path.join(TASKD_DATA_DIR, "keys", "server.crl")

RE_CONFIGUSER = re.compile(r'^\s*user\s*=(.*)$')
RE_USERKEY = re.compile(r'New user key: (.+)$', re.MULTILINE)


def lazyprop(fun):
    """
    Decorator which only evaluates the specified function when accessed.
    """
    name = '_lazy_' + fun.__name__

    @property
    def _lazy(self):
        val = getattr(self, name, None)
        if val is None:
            val = fun(self)
            setattr(self, name, val)
        return val

    return _lazy


class TaskdError(OSError):
    pass


def run_as_taskd_user():
    uid = pwd.getpwnam(TASKD_USER).pw_uid
    gid = grp.getgrnam(TASKD_GROUP).gr_gid
    os.setgid(gid)
    os.setuid(uid)


def taskd_cmd(cmd, *args, **kwargs):
    """
    Invoke taskd with the specified command with the privileges of the 'taskd'
    user and 'taskd' group.

    If 'capture_stdout' is passed as a keyword argument with the value True,
    the return value are the contents the command printed to stdout.
    """
    capture_stdout = kwargs.pop("capture_stdout", False)
    fun = subprocess.check_output if capture_stdout else subprocess.check_call
    return fun(
        [TASKD_COMMAND, cmd, "--data", TASKD_DATA_DIR] + list(args),
        preexec_fn=run_as_taskd_user,
        **kwargs
    )


def certtool_cmd(*args, **kwargs):
    """
    Invoke certtool from GNUTLS and return the output of the command.

    The provided arguments are added to the certtool command and keyword
    arguments are added to subprocess.check_output().

    Note that this will suppress all output of certtool and it will only be
    printed whenever there is an unsuccessful return code.
    """
    return subprocess.check_output(
        [CERTTOOL_COMMAND] + list(args),
        preexec_fn=lambda: os.umask(0077),
        stderr=subprocess.STDOUT,
        **kwargs
    )


def label(msg):
    if sys.stdout.isatty() or sys.stderr.isatty():
        sys.stderr.write(msg + "\n")


def mkpath(*args):
    return os.path.join(TASKD_DATA_DIR, "orgs", *args)


def mark_imperative(*path):
    """
    Mark the specified path as being imperatively managed by creating an empty
    file called ".imperative", so that it doesn't interfere with the
    declarative configuration.
    """
    open(os.path.join(mkpath(*path), ".imperative"), 'a').close()


def is_imperative(*path):
    """
    Check whether the given path is marked as imperative, see mark_imperative()
    for more information.
    """
    full_path = []
    for component in path:
        full_path.append(component)
        if os.path.exists(os.path.join(mkpath(*full_path), ".imperative")):
            return True
    return False


def fetch_username(org, key):
    for line in open(mkpath(org, "users", key, "config"), "r"):
        match = RE_CONFIGUSER.match(line)
        if match is None:
            continue
        return match.group(1).strip()
    return None


@contextmanager
def create_template(contents):
    """
    Generate a temporary file with the specified contents as a list of strings
    and yield its path as the context.
    """
    template = NamedTemporaryFile(mode="w", prefix="certtool-template")
    template.writelines(map(lambda l: l + "\n", contents))
    template.flush()
    yield template.name
    template.close()


def generate_key(org, user):
    if not IS_AUTO_CONFIG:
        msg = "Automatic PKI handling is disabled, you need to " \
              "manually issue a client certificate for user {}.\n"
        sys.stderr.write(msg.format(user))
        return

    basedir = os.path.join(TASKD_DATA_DIR, "keys", org, user)
    if os.path.exists(basedir):
        raise OSError("Keyfile directory for {} already exists.".format(user))

    privkey = os.path.join(basedir, "private.key")
    pubcert = os.path.join(basedir, "public.cert")

    try:
        os.makedirs(basedir, mode=0700)

        certtool_cmd("-p", "--bits", CERT_BITS, "--outfile", privkey)

        template_data = [
            "organization = {0}".format(org),
            "cn = {}".format(FQDN),
            "expiration_days = {}".format(CLIENT_EXPIRATION),
            "tls_www_client",
            "encryption_key",
            "signing_key"
        ]

        with create_template(template_data) as template:
            certtool_cmd(
                "-c",
                "--load-privkey", privkey,
                "--load-ca-privkey", CA_KEY,
                "--load-ca-certificate", CA_CERT,
                "--template", template,
                "--outfile", pubcert
            )
    except:
        rmtree(basedir)
        raise


def revoke_key(org, user):
    basedir = os.path.join(TASKD_DATA_DIR, "keys", org, user)
    if not os.path.exists(basedir):
        raise OSError("Keyfile directory for {} doesn't exist.".format(user))

    pubcert = os.path.join(basedir, "public.cert")

    expiration = "expiration_days = {}".format(CRL_EXPIRATION)

    with create_template([expiration]) as template:
        oldcrl = NamedTemporaryFile(mode="wb", prefix="old-crl")
        oldcrl.write(open(CRL_FILE, "rb").read())
        oldcrl.flush()
        certtool_cmd(
            "--generate-crl",
            "--load-crl", oldcrl.name,
            "--load-ca-privkey", CA_KEY,
            "--load-ca-certificate", CA_CERT,
            "--load-certificate", pubcert,
            "--template", template,
            "--outfile", CRL_FILE
        )
        oldcrl.close()
    rmtree(basedir)


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


class User(object):
    def __init__(self, org, name, key):
        self.__org = org
        self.name = name
        self.key = key

    def export(self):
        credentials = '/'.join([self.__org, self.name, self.key])
        allow_unquoted = string.ascii_letters + string.digits + "/-_."
        if not all((c in allow_unquoted) for c in credentials):
            credentials = "'" + credentials.replace("'", r"'\''") + "'"

        script = []

        if IS_AUTO_CONFIG:
            pubcert = getkey(self.__org, self.name, "public.cert")
            privkey = getkey(self.__org, self.name, "private.key")
            cacert = getkey("ca.cert")

            keydir = "${TASKDATA:-$HOME/.task}/keys"

            script += [
                "umask 0077",
                'mkdir -p "{}"'.format(keydir),
                mktaskkey("certificate", os.path.join(keydir, "public.cert"),
                          pubcert),
                mktaskkey("key", os.path.join(keydir, "private.key"), privkey),
                mktaskkey("ca", os.path.join(keydir, "ca.cert"), cacert)
            ]

        script.append(
            "task config taskd.credentials -- {}".format(credentials)
        )

        return "\n".join(script) + "\n"


class Group(object):
    def __init__(self, org, name):
        self.__org = org
        self.name = name


class Organisation(object):
    def __init__(self, name, ignore_imperative):
        self.name = name
        self.ignore_imperative = ignore_imperative

    def add_user(self, name):
        """
        Create a new user along with a certificate and key.

        Returns a 'User' object or None if the user already exists.
        """
        if self.ignore_imperative and is_imperative(self.name):
            return None
        if name not in self.users.keys():
            output = taskd_cmd("add", "user", self.name, name,
                               capture_stdout=True)
            key = RE_USERKEY.search(output)
            if key is None:
                msg = "Unable to find key while creating user {}."
                raise TaskdError(msg.format(name))

            generate_key(self.name, name)
            newuser = User(self.name, name, key.group(1))
            self._lazy_users[name] = newuser
            return newuser
        return None

    def del_user(self, name):
        """
        Delete a user and revoke its keys.
        """
        if name in self.users.keys():
            user = self.get_user(name)
            if self.ignore_imperative and \
               is_imperative(self.name, "users", user.key):
                return

            # Work around https://bug.tasktools.org/browse/TD-40:
            rmtree(mkpath(self.name, "users", user.key))

            revoke_key(self.name, name)
            del self._lazy_users[name]

    def add_group(self, name):
        """
        Create a new group.

        Returns a 'Group' object or None if the group already exists.
        """
        if self.ignore_imperative and is_imperative(self.name):
            return None
        if name not in self.groups.keys():
            taskd_cmd("add", "group", self.name, name)
            newgroup = Group(self.name, name)
            self._lazy_groups[name] = newgroup
            return newgroup
        return None

    def del_group(self, name):
        """
        Delete a group.
        """
        if name in self.users.keys():
            if self.ignore_imperative and \
               is_imperative(self.name, "groups", name):
                return
            taskd_cmd("remove", "group", self.name, name)
            del self._lazy_groups[name]

    def get_user(self, name):
        return self.users.get(name)

    @lazyprop
    def users(self):
        result = {}
        for key in os.listdir(mkpath(self.name, "users")):
            user = fetch_username(self.name, key)
            if user is not None:
                result[user] = User(self.name, user, key)
        return result

    def get_group(self, name):
        return self.groups.get(name)

    @lazyprop
    def groups(self):
        result = {}
        for group in os.listdir(mkpath(self.name, "groups")):
            result[group] = Group(self.name, group)
        return result


class Manager(object):
    def __init__(self, ignore_imperative=False):
        """
        Instantiates an organisations manager.

        If ignore_imperative is True, all actions that modify data are checked
        whether they're created imperatively and if so, they will result in no
        operation.
        """
        self.ignore_imperative = ignore_imperative

    def add_org(self, name):
        """
        Create a new organisation.

        Returns an 'Organisation' object or None if the organisation already
        exists.
        """
        if name not in self.orgs.keys():
            taskd_cmd("add", "org", name)
            neworg = Organisation(name, self.ignore_imperative)
            self._lazy_orgs[name] = neworg
            return neworg
        return None

    def del_org(self, name):
        """
        Delete and revoke keys of an organisation with all its users and
        groups.
        """
        org = self.get_org(name)
        if org is not None:
            if self.ignore_imperative and is_imperative(name):
                return
            for user in org.users.keys():
                org.del_user(user)
            for group in org.groups.keys():
                org.del_group(group)
            taskd_cmd("remove", "org", name)
            del self._lazy_orgs[name]

    def get_org(self, name):
        return self.orgs.get(name)

    @lazyprop
    def orgs(self):
        result = {}
        for org in os.listdir(mkpath()):
            result[org] = Organisation(org, self.ignore_imperative)
        return result


class OrganisationType(click.ParamType):
    name = 'organisation'

    def convert(self, value, param, ctx):
        org = Manager().get_org(value)
        if org is None:
            self.fail("Organisation {} does not exist.".format(value))
        return org

ORGANISATION = OrganisationType()


@click.group()
@click.pass_context
def cli(ctx):
    """
    Manage Taskserver users and certificates
    """
    for path in (CA_KEY, CA_CERT, CRL_FILE):
        if not os.path.exists(path):
            msg = "CA setup not done or incomplete, missing file {}."
            ctx.fail(msg.format(path))


@cli.group("org")
def org_cli():
    """
    Manage organisations
    """
    pass


@cli.group("user")
def user_cli():
    """
    Manage users
    """
    pass


@cli.group("group")
def group_cli():
    """
    Manage groups
    """
    pass


@user_cli.command("list")
@click.argument("organisation", type=ORGANISATION)
def list_users(organisation):
    """
    List all users belonging to the specified organisation.
    """
    label("The following users exists for {}:".format(organisation.name))
    for user in organisation.users.values():
        sys.stdout.write(user.name + "\n")


@group_cli.command("list")
@click.argument("organisation", type=ORGANISATION)
def list_groups(organisation):
    """
    List all users belonging to the specified organisation.
    """
    label("The following users exists for {}:".format(organisation.name))
    for group in organisation.groups.values():
        sys.stdout.write(group.name + "\n")


@org_cli.command("list")
def list_orgs():
    """
    List available organisations
    """
    label("The following organisations exist:")
    for org in Manager().orgs:
        sys.stdout.write(org.name + "\n")


@user_cli.command("getkey")
@click.argument("organisation", type=ORGANISATION)
@click.argument("user")
def get_uuid(organisation, user):
    """
    Get the UUID of the specified user belonging to the specified organisation.
    """
    userobj = organisation.get_user(user)
    if userobj is None:
        msg = "User {} doesn't exist in organisation {}."
        sys.exit(msg.format(userobj.name, organisation.name))

    label("User {} has the following UUID:".format(userobj.name))
    sys.stdout.write(user.key + "\n")


@user_cli.command("export")
@click.argument("organisation", type=ORGANISATION)
@click.argument("user")
def export_user(organisation, user):
    """
    Export user of the specified organisation as a series of shell commands
    that can be used on the client side to easily import the certificates.

    Note that the private key will be exported as well, so use this with care!
    """
    userobj = organisation.get_user(user)
    if userobj is None:
        msg = "User {} doesn't exist in organisation {}."
        sys.exit(msg.format(user, organisation.name))

    sys.stdout.write(userobj.export())


@org_cli.command("add")
@click.argument("name")
def add_org(name):
    """
    Create an organisation with the specified name.
    """
    if os.path.exists(mkpath(name)):
        msg = "Organisation with name {} already exists."
        sys.exit(msg.format(name))

    taskd_cmd("add", "org", name)
    mark_imperative(name)


@org_cli.command("remove")
@click.argument("name")
def del_org(name):
    """
    Delete the organisation with the specified name.

    All of the users and groups will be deleted as well and client certificates
    will be revoked.
    """
    Manager().del_org(name)
    msg = ("Organisation {} deleted. Be sure to restart the Taskserver"
           " using 'systemctl restart taskserver.service' in order for"
           " the certificate revocation to apply.")
    click.echo(msg.format(name), err=True)


@user_cli.command("add")
@click.argument("organisation", type=ORGANISATION)
@click.argument("user")
def add_user(organisation, user):
    """
    Create a user for the given organisation along with a client certificate
    and print the key of the new user.

    The client certificate along with it's public key can be shown via the
    'user export' subcommand.
    """
    userobj = organisation.add_user(user)
    if userobj is None:
        msg = "User {} already exists in organisation {}."
        sys.exit(msg.format(user, organisation))
    else:
        mark_imperative(organisation.name, "users", userobj.key)


@user_cli.command("remove")
@click.argument("organisation", type=ORGANISATION)
@click.argument("user")
def del_user(organisation, user):
    """
    Delete a user from the given organisation.

    This will also revoke the client certificate of the given user.
    """
    organisation.del_user(user)
    msg = ("User {} deleted. Be sure to restart the Taskserver using"
           " 'systemctl restart taskserver.service' in order for the"
           " certificate revocation to apply.")
    click.echo(msg.format(user), err=True)


@group_cli.command("add")
@click.argument("organisation", type=ORGANISATION)
@click.argument("group")
def add_group(organisation, group):
    """
    Create a group for the given organisation.
    """
    groupobj = organisation.add_group(group)
    if groupobj is None:
        msg = "Group {} already exists in organisation {}."
        sys.exit(msg.format(group, organisation))
    else:
        mark_imperative(organisation.name, "groups", groupobj.name)


@group_cli.command("remove")
@click.argument("organisation", type=ORGANISATION)
@click.argument("group")
def del_group(organisation, group):
    """
    Delete a group from the given organisation.
    """
    organisation.del_group(group)
    click("Group {} deleted.".format(group), err=True)


def add_or_delete(old, new, add_fun, del_fun):
    """
    Given an 'old' and 'new' list, figure out the intersections and invoke
    'add_fun' against every element that is not in the 'old' list and 'del_fun'
    against every element that is not in the 'new' list.

    Returns a tuple where the first element is the list of elements that were
    added and the second element consisting of elements that were deleted.
    """
    old_set = set(old)
    new_set = set(new)
    to_delete = old_set - new_set
    to_add = new_set - old_set
    for elem in to_delete:
        del_fun(elem)
    for elem in to_add:
        add_fun(elem)
    return to_add, to_delete


@cli.command("process-json")
@click.argument('json-file', type=click.File('rb'))
def process_json(json_file):
    """
    Create and delete users, groups and organisations based on a JSON file.

    The structure of this file is exactly the same as the
    'services.taskserver.organisations' option of the NixOS module and is used
    for declaratively adding and deleting users.

    Hence this subcommand is not recommended outside of the scope of the NixOS
    module.
    """
    data = json.load(json_file)

    mgr = Manager(ignore_imperative=True)
    add_or_delete(mgr.orgs.keys(), data.keys(), mgr.add_org, mgr.del_org)

    for org in mgr.orgs.values():
        if is_imperative(org.name):
            continue
        add_or_delete(org.users.keys(), data[org.name]['users'],
                      org.add_user, org.del_user)
        add_or_delete(org.groups.keys(), data[org.name]['groups'],
                      org.add_group, org.del_group)


if __name__ == '__main__':
    cli()
