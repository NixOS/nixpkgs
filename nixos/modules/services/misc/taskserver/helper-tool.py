import grp
import json
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


class User(object):
    def __init__(self, org, name, key):
        self.__org = org
        self.name = name
        self.key = key

    def export(self):
        pubcert = getkey(self.__org, self.name, "public.cert")
        privkey = getkey(self.__org, self.name, "private.key")
        cacert = getkey("ca.cert")

        keydir = "${TASKDATA:-$HOME/.task}/keys"

        credentials = '/'.join([self.__org, self.name, self.key])
        allow_unquoted = string.ascii_letters + string.digits + "/-_."
        if not all((c in allow_unquoted) for c in credentials):
            credentials = "'" + credentials.replace("'", r"'\''") + "'"

        script = [
            "umask 0077",
            'mkdir -p "{}"'.format(keydir),
            mktaskkey("certificate", os.path.join(keydir, "public.cert"),
                      pubcert),
            mktaskkey("key", os.path.join(keydir, "private.key"), privkey),
            mktaskkey("ca", os.path.join(keydir, "ca.cert"), cacert),
            "task config taskd.credentials -- {}".format(credentials)
        ]

        return "\n".join(script) + "\n"


class Group(object):
    def __init__(self, org, name):
        self.__org = org
        self.name = name


class Organisation(object):
    def __init__(self, name):
        self.name = name

    def add_user(self, name):
        """
        Create a new user along with a certificate and key.

        Returns a 'User' object or None if the user already exists.
        """
        if name not in self.users.keys():
            output = taskd_cmd("add", "user", self.name, name,
                               capture_stdout=True)
            key = RE_USERKEY.search(output)
            if key is None:
                msg = "Unable to find key while creating user {}."
                raise TaskdError(msg.format(name))

            generate_key(self.name, name)
            newuser = User(self.name, name, key)
            self._lazy_users[name] = newuser
            return newuser
        return None

    def del_user(self, name):
        """
        Delete a user and revoke its keys.
        """
        sys.stderr.write("Delete user {}.".format(name))
        # TODO: deletion!

    def add_group(self, name):
        """
        Create a new group.

        Returns a 'Group' object or None if the group already exists.
        """
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
        sys.stderr.write("Delete group {}.".format(name))
        # TODO: deletion!

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
    def add_org(self, name):
        """
        Create a new organisation.

        Returns an 'Organisation' object or None if the organisation already
        exists.
        """
        if name not in self.orgs.keys():
            taskd_cmd("add", "org", name)
            neworg = Organisation(name)
            self._lazy_orgs[name] = neworg
            return neworg
        return None

    def del_org(self, name):
        """
        Delete and revoke keys of an organisation with all its users and
        groups.
        """
        sys.stderr.write("Delete org {}.".format(name))
        # TODO: deletion!

    def get_org(self, name):
        return self.orgs.get(name)

    @lazyprop
    def orgs(self):
        result = {}
        for org in os.listdir(mkpath()):
            result[org] = Organisation(org)
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
def cli():
    """
    Manage Taskserver users and certificates
    """
    pass


@cli.command("list-users")
@click.argument("organisation", type=ORGANISATION)
def list_users(organisation):
    """
    List all users belonging to the specified organisation.
    """
    label("The following users exists for {}:".format(organisation.name))
    for user in organisation.users.values():
        sys.stdout.write(user.name + "\n")


@cli.command("list-orgs")
def list_orgs():
    """
    List available organisations
    """
    label("The following organisations exist:")
    for org in Manager().orgs:
        sys.stdout.write(org.name + "\n")


@cli.command("get-uuid")
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


@cli.command("export-user")
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
        sys.exit(msg.format(userobj.name, organisation.name))

    sys.stdout.write(userobj.export())


@cli.command("add-org")
@click.argument("name")
def add_org(name):
    """
    Create an organisation with the specified name.
    """
    if os.path.exists(mkpath(name)):
        msg = "Organisation with name {} already exists."
        sys.exit(msg.format(name))

    taskd_cmd("add", "org", name)


@cli.command("add-user")
@click.argument("organisation", type=ORGANISATION)
@click.argument("user")
def add_user(organisation, user):
    """
    Create a user for the given organisation along with a client certificate
    and print the key of the new user.

    The client certificate along with it's public key can be shown via the
    'export-user' subcommand.
    """
    userobj = organisation.add_user(user)
    if userobj is None:
        msg = "User {} already exists in organisation {}."
        sys.exit(msg.format(user, organisation))


@cli.command("add-group")
@click.argument("organisation", type=ORGANISATION)
@click.argument("group")
def add_group(organisation, group):
    """
    Create a group for the given organisation.
    """
    userobj = organisation.add_group(group)
    if userobj is None:
        msg = "Group {} already exists in organisation {}."
        sys.exit(msg.format(group, organisation))


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

    mgr = Manager()
    add_or_delete(mgr.orgs.keys(), data.keys(), mgr.add_org, mgr.del_org)

    for org in mgr.orgs.values():
        add_or_delete(org.users.keys(), data[org.name]['users'],
                      org.add_user, org.del_user)
        add_or_delete(org.groups.keys(), data[org.name]['groups'],
                      org.add_group, org.del_group)


if __name__ == '__main__':
    cli()
