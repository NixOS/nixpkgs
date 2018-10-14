#! @python@

import dbus
import os
from pathlib import Path
import re
import signal
import subprocess
from syslog import openlog, syslog, LOG_NOTICE, LOG_ERR
import sys
from typing import cast, Dict, Set, NewType, List, Tuple, NamedTuple, Any

out = Path("@out@")

# To be robust against interruption, record what units need to be started etc.
START_UNIT_FILE = Path("/run/systemd/start-list")
RESTART_UNIT_FILE = Path("/run/systemd/restart-list")
RELOAD_UNIT_FILE = Path("/run/systemd/reload-list")

def print_err(*s: Any) -> None:
    print(*s, file=sys.stderr)

def die_with_usage() -> None:
    msg = """
        Usage: {prog} [switch|boot|test]

        switch:       make the configuration the boot default and activate now
        boot:         make the configuration the boot default
        test:         activate the configuration, but don\'t make it the boot default
        dry-activate: show what would be done if this configuration were activated
    """.format(prog=sys.argv[0])
    print_err(msg)
    sys.exit(1)

def die(why: str) -> None:
    print_err("error:", why)
    sys.exit(1)

def read_if_exists(path: Path, otherwise: str) -> str:
    if path.is_file():
        return path.read_text()
    else:
        return otherwise

# This is a NixOS installation if it has /etc/NIXOS or a proper
# /etc/os-release.
def is_nixos() -> bool:
    if Path("/etc/NIXOS").is_file():
        return True

    os_release = read_if_exists(Path("/etc/os-release"), otherwise="")
    if os_release.find("ID=nixos") != -1:
        return True

    return False

# A systemd unit name.
UnitName = NewType('UnitName', str)
ActiveUnit = NamedTuple('ActiveUnit',
                        [('load', str), ('state', str), ('sub_state', str)])

def get_active_units() -> Dict[UnitName, ActiveUnit]:
    bus = dbus.SystemBus()
    obj = bus.get_object('org.freedesktop.systemd1',
                         '/org/freedesktop/systemd1')

    units = obj.ListUnitsByPatterns([], [],
                                    dbus_interface='org.freedesktop.systemd1.Manager')
    res = {}
    for unit in units:
        (id, description, load_state, active_state, sub_state,
            following, unit_path, job_id, job_type, job_path) = unit
        if following != '':
            continue
        if job_id == 0 and active_state == 'inactive':
            continue
        res[UnitName(id)] = ActiveUnit(load=load_state,
                                       state=active_state,
                                       sub_state=sub_state)

    return res

Mountpoint = NewType('Mountpoint', str)
BlockDevice = NewType('BlockDevice', str)
FsMount = NamedTuple('FsMount', [('device', BlockDevice),
                                 ('fs_type', str),
                                 ('options', str)])
SwapMount = NamedTuple('SwapMount', [('options', str)])

def parse_fstab(filename: Path) -> Tuple[Dict[Mountpoint, FsMount], Dict[BlockDevice, SwapMount]]:
    fss = {}  # type: Dict[Mountpoint, FsMount]
    swaps = {}  # type: Dict[BlockDevice, SwapMount]
    for line in filename.read_text().split('\n'):
        line = line.strip()
        line = re.sub(r'^\s*#.*', '', line)
        if line.strip() == '':
            continue

        xs = re.split(' ', line)
        device = BlockDevice(xs[0])
        mountpoint = Mountpoint(xs[1])
        fs_type = xs[2]
        options = xs[3] if len(xs) > 4 else ''
        if fs_type == 'swap':
            swaps[device] = SwapMount(options)
        else:
            fss[mountpoint] = FsMount(device, fs_type, options)

    return (fss, swaps)

def parse_unit(filename: Path) -> Dict[str, str]:
    info = {}
    info.update(parse_key_values(read_if_exists(filename, '')))
    overrides = filename.with_name(filename.name + ".d") / "overrides.conf"
    info.update(parse_key_values(read_if_exists(overrides, '')))
    return info

def parse_key_values(s: str) -> Dict[str, str]:
    info = {}
    for line in s.split('\n'):
        m = re.match(r'^([^=]+)=(.*)$', line)
        if m is None:
            die('error parsing unit')
        else:
            info[m.group(1)] = m.group(2)

    return info

def bool_is_true(s: str) -> bool:
    return s in ['yes', 'true']

# As a fingerprint for determining whether a unit has changed, we use
# its absolute path. If it has an override file, we append *its*
# absolute path as well.
def fingerprint_unit(filename: Path) -> str:
    fprint = str(filename.resolve())
    override = filename.with_name(filename.name+".d") / "overrides.conf"
    if override.is_file():
        fprint += ' ' + str(override.resolve())
    return fprint

class UnitTransitions:
    def __init__(self, dry_run: bool) -> None:
        def read_unit_list(fname: Path) -> Set[UnitName]:
            units = read_if_exists(fname, "").split('\n')
            return { UnitName(unit) for unit in units }

        self.dry_run = dry_run
        self.to_stop = set()  # type: Set[UnitName]
        self.to_skip = set()  # type: Set[UnitName]
        self.to_start = read_unit_list(START_UNIT_FILE)
        self.to_restart = read_unit_list(RESTART_UNIT_FILE)
        self.to_reload = read_unit_list(RELOAD_UNIT_FILE)
        self.to_filter = set()  # type: Set[UnitName]

    # =========================
    # Record unit transitions
    # =========================

    def _record_unit(self, filename: Path, unit: UnitName) -> None:
        if not self.dry_run:
            with open(filename, 'a') as f:
                f.write(unit)
                f.write('\n')

    def stop_unit(self, unit: UnitName) -> None:
        self.to_stop.add(unit)

    def skip_unit(self, unit: UnitName) -> None:
        self.to_skip.add(unit)

    def start_unit(self, unit: UnitName) -> None:
        self.to_start.add(unit)
        self._record_unit(START_UNIT_FILE, unit)

    def restart_unit(self, unit: UnitName) -> None:
        self.to_restart.add(unit)
        self._record_unit(RESTART_UNIT_FILE, unit)

    def reload_unit(self, unit: UnitName) -> None:
        self.to_reload.add(unit)
        self._record_unit(RELOAD_UNIT_FILE, unit)

    def filter_unit(self, unit: UnitName) -> None:
        self.to_filter.add(unit)

    # =========================
    # Accessors
    # =========================

    def _filter_units(self, units: Set[UnitName]) -> Set[UnitName]:
        return { unit
                 for unit in units
                 if unit not in self.to_filter }

    def filtered_units_to_stop(self) -> Set[UnitName]:
        return self._filter_units(self.to_stop)

    def filtered_units_to_start(self) -> Set[UnitName]:
        return self._filter_units(self.to_start)

    def units_to_stop(self) -> Set[UnitName]:
        return self.to_stop

    def units_to_start(self) -> Set[UnitName]:
        return self.to_start

    def units_to_restart(self) -> Set[UnitName]:
        return self.to_restart

    def units_to_reload(self) -> Set[UnitName]:
        return self.to_reload

    def units_to_skip(self) -> Set[UnitName]:
        return self.to_skip

    def summary(self) -> str:
        res = []  # type: List[str]

        def action(units: Set[UnitName], descr: str) -> None:
            if len(units) > 0:
                res += [descr + ": " + ', '.join(units)]

        action(self.filtered_units_to_stop(),
               "would stop the following units")

        action(self.units_to_skip(),
               "would NOT stop the following changed units")

        action(self.units_to_restart(),
               "would restart the following units")

        action(self.filtered_units_to_start(),
               "would start the following units")

        action(self.units_to_reload(),
               "would reload the following units")

        return '\n'.join(res)

# Figure out what units need to be stopped, started, restarted or reloaded.
def determine_unit_transitions(dry_run: bool) -> UnitTransitions:
    transitions = UnitTransitions(dry_run)
    active_prev = get_active_units()

    for unit, state in active_prev.items():
        base_unit = unit  # type: str
        prev_unit_file = Path("/etc/systemd/system") / Path(base_unit)
        new_unit_file = out / "etc/systemd/system" / Path(base_unit)

        # Detect template instances.
        m = re.match(r"^(.*)@[^\.]*\.(.*)$", unit)
        if not prev_unit_file.exists() \
           and not new_unit_file.exists() \
           and m is not None:
            base_unit = "%s@%s" % (m.group(1), m.group(1))
            prev_unit_file = Path("/etc/systemd/system") / Path(base_unit)
            new_unit_file = out / "etc/systemd/system" / Path(base_unit)

        base_name = re.sub(r"\.[a-z]*$", "", base_unit)
        prev_exists = prev_unit_file.exists()
        new_exists = new_unit_file.exists()
        if prev_exists and state.state in ['active', 'activating']:
            if (not new_exists) or new_unit_file.resolve() == "/dev/null":
                # Ignore (i.e. never stop) these units:
                if unit == "system.slice":
                    # TODO: This can be removed a few months after 18.09 is out
                    # (i.e. after everyone switched away from 18.03).
                    # Problem: Restarting (stopping) system.slice would not only
                    # stop X11 but also most system units/services. We obviously
                    # don't want this happening to users when they switch from 18.03
                    # to 18.09 or nixos-unstable.
                    # Reason: The following change in systemd:
                    # https://github.com/systemd/systemd/commit/d8e5a9338278d6602a0c552f01f298771a384798
                    # The commit adds system.slice to the perpetual units, which
                    # means removing the unit file and adding it to the source code.
                    # This is done so that system.slice can't be stopped anymore but
                    # in our case it ironically would cause this script to stop
                    # system.slice because the unit was removed (and an older
                    # systemd version is still running).
                    continue

                unit_info = parse_unit(prev_unit_file)
                if bool_is_true(unit_info.get('X-StopOnRemoval', 'yes')):
                    transitions.stop_unit(unit)

            elif unit.endswith('.target'):
                unit_info = parse_unit(new_unit_file)

                # Cause all active target units to be restarted below.
                # This should start most changed units we stop here as
                # well as any new dependencies (including new mounts and
                # swap devices).  FIXME: the suspend target is sometimes
                # active after the system has resumed, which probably
                # should not be the case.  Just ignore it.
                suspend_targets = [ "suspend.target", "hibernate.target", "hybrid-sleep.target"]
                if unit not in suspend_targets:
                    if not bool_is_true(unit_info.get('RefuseManualStart', 'no')):
                        transitions.start_unit(unit)
                        # Don't spam the user with target units that always get started.
                        transitions.filter_unit(unit)

                # Stop targets that have X-StopOnReconfiguration set.
                # This is necessary to respect dependency orderings
                # involving targets: if unit X starts after target Y and
                # target Y starts after unit Z, then if X and Z have both
                # changed, then X should be restarted after Z.  However,
                # if target Y is in the "active" state, X and Z will be
                # restarted at the same time because X's dependency on Y
                # is already satisfied.  Thus, we need to stop Y first.
                # Stopping a target generally has no effect on other units
                # (unless there is a PartOf dependency), so this is just a
                # bookkeeping thing to get systemd to do the right thing.
                if bool_is_true(unit_info.get('X-StopOnReconfiguration', 'no')):
                    transitions.stop_unit(unit)

            elif fingerprint_unit(prev_unit_file) != fingerprint_unit(new_unit_file):
                system_targets = ['sysinit.target', 'basic.target', 'multi-user.target', 'graphical.target']
                if unit in system_targets:
                    # Do nothing.  These cannot be restarted directly.
                    pass
                elif unit.endswith('.mount'):
                    # Reload the changed mount unit to force a remount.
                    transitions.reload_unit(unit)

                elif unit.endswith('.socket') or unit.endswith('.path') or unit.endswith('.slice'):
                    # FIXME: do something?
                    pass
                else:
                    unit_info = parse_unit(new_unit_file)
                    reload_if_changed = bool_is_true(unit_info.get('X-ReloadIfChanged', 'no'))
                    restart_if_changed = bool_is_true(unit_info.get('X-RestartIfChanged', 'yes'))
                    refuse_manual_stop = bool_is_true(unit_info.get('RefuseManualStop', 'no'))
                    stop_if_changed = bool_is_true(unit_info.get('X-StopIfChanged', 'yes'))

                    if reload_if_changed:
                        transitions.reload_unit(unit)
                    elif not restart_if_changed or refuse_manual_stop:
                        transitions.skip_unit(unit)
                    else:
                        if not stop_if_changed:
                            # This unit should be restarted instead of
                            # stopped and started.
                            transitions.restart_unit(unit)
                        else:
                            # If this unit is socket-activated, then stop the
                            # socket unit(s) as well, and restart the
                            # socket(s) instead of the service.
                            socketActivated = False
                            if unit.endswith('.service'):
                                sockets = list(map(UnitName, unit_info.get('Sockets', '').split()))
                                if len(sockets) == 0:
                                    sockets = [UnitName("{base_name}.socket".format(base_name=base_name))]

                                for socket in sockets:
                                    if socket in active_prev:
                                        transitions.stop_unit(socket)
                                        transitions.start_unit(socket)
                                        socket_activated = True

                            # If the unit is not socket-activated, record
                            # that this unit needs to be started below.
                            # We write this to a file to ensure that the
                            # service gets restarted if we're interrupted.
                            if not socket_activated:
                                transitions.start_unit(unit)

                            transitions.stop_unit(unit)

    return transitions

def path_to_unit_name(path: Path) -> UnitName:
    # Use current version of systemctl binary before daemon is reexeced.
    args = ["/run/current-system/sw/bin/systemd-escape",
            "--suffix=mount", "-p", str(path)]
    output = subprocess.check_output(args)
    return UnitName(output.strip())

# Compare the previous and new fstab to figure out which filesystems
# need a remount or need to be unmounted.  New filesystems are mounted
# automatically by starting local-fs.target.  FIXME: might be nicer if
# we generated units for all mounts; then we could unify this with the
# unit checking code above.
def determine_mount_changes(transitions: UnitTransitions) -> None:
    prev_fss, prev_swaps = parse_fstab(Path('/etc/fstab'))
    new_fss, new_swaps = parse_fstab(out / Path('etc/fstab'))
    for mountpoint in prev_fss.keys():
        unit = path_to_unit_name(Path(mountpoint))
        if mountpoint not in new_fss:
            # Filesystem entry disappeared, so unmount it.
            transitions.stop_unit(unit)
            continue

        new = new_fss[mountpoint]
        prev = prev_fss[mountpoint]
        if prev.fs_type != new.fs_type or \
           prev.device != new.device:
            # Filesystem type or device changed, so unmount and mount it.
            transitions.stop_unit(unit)
            transitions.start_unit(unit)
        elif prev.options != new.options:
            # Mount options changes, so remount it.
            transitions.reload_unit(unit)

    # Also handles swap devices.
    for device in prev_swaps.keys():
        if device not in new_swaps:
            # Swap entry disappeared, so turn it off.  Can't use
            # "systemctl stop" here because systemd has lots of alias
            # units that prevent a stop from actually calling
            # "swapoff".
            print_err("stopping swap device:", device)
            subprocess.check_call(["@utillinux@/sbin/swapoff", device])

        # FIXME: update swap options (i.e. its priority).

def reload_user_units() -> None:
    args = ["@systemd@/bin/loginctl", "list-users", "--no-legend"]
    active_users = subprocess.check_output(args).split('\n')
    for f in active_users:
        m = re.match(r"^\s*(?P<qid>\d+)\s+(?P<user>\S+)", f)
        if m is None:
            continue
        uid = m.group(1)
        user = m.group(2)
        print_err("reloading user units for {user}...".format(user=user))

        subprocess.call(["@su@", "-s", "@shell@", "-l", user,
                        "-c", "XDG_RUNTIME_DIR=/run/user/{uid} @systemd@/bin/systemctl --user daemon-reload".format(uid=uid)])
        subprocess.call(["@su@", "-s", "@shell@", "-l", user,
                        "-c", "XDG_RUNTIME_DIR=/run/user/{uid} @systemd@/bin/systemctl --user start nixos-activation.service".format(uid=uid)])


def main() -> None:
    if len(sys.argv) < 1:
        die_with_usage()

    action = sys.argv[1]
    valid_modes = ["switch", "boot", "test", "dry-activate"]
    if action not in valid_modes:
        die_with_usage()

    if not is_nixos():
        die("This is not a NixOS installation!")

    openlog("nixos")

    # Install or update the bootloader.
    if action == "switch" or action == "boot":
        subprocess.check_call(["@installBootLoader@", out])

    # Just in case the new configuration hangs the system, do a sync now.
    if os.environ.get('NIXOS_NO_SYNC') != "1":
        subprocess.check_call(["@coreutils@/bin/sync", "-f", "/nix/store"])

    if action == "boot":
        sys.exit(0)

    # Check if we can activate the new configuration.
    old_version = read_if_exists(Path("/run/current-system/init-interface-version"), otherwise="")
    new_version = (out / "init-interface-version").read_text()

    if new_version != old_version:
        print_err("""
            Warning: the new NixOS configuration has an ‘init’ that is
            incompatible with the current configuration.  The new configuration
            won\'t take effect until you reboot the system.
        """)
        sys.exit(100)

    # Ignore SIGHUP so that we're not killed if we're running on (say)
    # virtual console 1 and we restart the "tty1" unit.
    signal.signal(signal.SIGPIPE, signal.SIG_IGN)

    active_prev = get_active_units()
    transitions = determine_unit_transitions(dry_run=action == 'dry-activate')

    # Should we have systemd re-exec itself?
    prev_systemd = Path("/unknown")
    pid1exe = Path("/proc/1/exe")
    if pid1exe.exists():
        prev_systemd = pid1exe.resolve()

    new_systemd = Path("@systemd@/lib/systemd/systemd").resolve()
    restart_systemd = prev_systemd != new_systemd

    units_to_stop = transitions.units_to_stop()
    units_to_start = transitions.units_to_start()
    units_to_restart = transitions.units_to_restart()
    units_to_skip = transitions.units_to_skip()

    # Show dry-run actions.
    if action == "dry-activate":
        print_err(transitions.summary())
        if restart_systemd:
            print_err("would restart systemd")
        sys.exit()

    syslog(LOG_NOTICE, "switching to system configuration {out}".format(out=out))

    if len(transitions.units_to_stop()) > 0:
        if len(transitions.filtered_units_to_stop()) > 0:
            print_err("stopping the following units: ",
                    ', '.join(transitions.filtered_units_to_stop()))
        # Use current version of systemctl binary before daemon is reexeced.
        subprocess.check_call(["/run/current-system/sw/bin/systemctl", "stop", "--"] +
                            sorted(transitions.units_to_stop())) # FIXME: ignore errors?

    if len(transitions.units_to_skip()) > 0:
        print_err("NOT restarting the following changed units: ",
                ', '.join(sorted(transitions.units_to_skip())))

    # Activate the new configuration (i.e., update /etc, make accounts,
    # and so on).
    print_err("activating the configuration...")
    res = 0
    if subprocess.call([out / "activate", out]) != 0:
        res = 2

    # Restart systemd if necessary.
    if restart_systemd:
        print_err("restarting systemd...")
        if subprocess.call(["@systemd@/bin/systemctl", "daemon-reexec"]) != 0:
            res = 2

    # Forget about previously failed services.
    subprocess.call(["@systemd@/bin/systemctl", "reset-failed"])

    # Make systemd reload its units.
    if subprocess.call(["@systemd@/bin/systemctl", "daemon-reload"]) != 0:
        res = 3

    reload_user_units()

    # Set the new tmpfiles
    print_err("setting up tmpfiles")
    if subprocess.call(["@systemd@/bin/systemd-tmpfiles", "--create", "--remove",
                        "--exclude-prefix=/dev"]) != 0:
        res = 3

    # Reload units that need it. This includes remounting changed mount
    # units.
    if len(transitions.units_to_reload()) > 0:
        units = sorted(transitions.units_to_reload())
        print_err("reloading the following units: ", ", ".join(units))
        if subprocess.call(["@systemd@/bin/systemctl", "reload", "--"] +
                           cast(List[str], units)) != 0:
            res = 4
        os.unlink(RELOAD_UNIT_FILE)

    # Restart changed services (those that have to be restarted rather
    # than stopped and started).
    if len(transitions.units_to_restart()) > 0:
        units = sorted(transitions.units_to_restart())
        print_err("restarting the following units: ", ", ".join(units))
        if subprocess.call(["@systemd@/bin/systemctl", "restart", "--"] +
                           cast(List[str], units)) != 0:
            res = 4
        os.unlink(RESTART_UNIT_FILE)

    # Start all active targets, as well as changed units we stopped above.
    # The latter is necessary because some may not be dependencies of the
    # targets (i.e., they were manually started).  FIXME: detect units
    # that are symlinks to other units.  We shouldn't start both at the
    # same time because we'll get a "Failed to add path to set" error from
    # systemd.
    if len(transitions.filtered_units_to_start()) > 0:
        print("starting the following units: ",
            ", ".join(transitions.filtered_units_to_start()))
    if subprocess.call(["@systemd@/bin/systemctl", "start", "--"] +
                        sorted(transitions.units_to_start())) != 0:
        res = 4
    os.unlink(START_UNIT_FILE)

    # Print failed and new units.
    failed = []
    new = []
    active_new = get_active_units()
    for unit, state in active_new.items():
        if state.state == 'failed':
            failed.append(unit)
        elif state.state == 'auto-restart':
            # A unit in auto-restart state is a failure *if* it previously failed to start
            lines = subprocess.check_output(['systemd@/bin/systemctl', 'show', unit])
            info = parse_key_values(lines.split('\n'))

            if info['ExecMainStatus'] != '0':
                failed.append(unit)
        elif state.state != 'failed' and unit not in active_prev:
            new.append(unit)

    if len(new) > 0:
        print_err("the following new units were started: ", ", ".join(sorted(new)))

    if len(failed) > 0:
        print_err("warning: the following units failed: ", ", ".join(sorted(failed)))
        for unit in failed:
            print_err('')
            cmd = "COLUMNS=1000 @systemd@/bin/systemctl status --no-pager '{unit}' >&2".format(unit=unit)
            subprocess.check_call(cmd, shell=True)
        res = 4

    if res == 0:
        syslog(LOG_NOTICE, "finished switching to system configuration {out}".format(out=out))
    else:
        syslog(LOG_ERR, "switching to system configuration {out} failed (status {res})".
            format(out=out, res=res))

    sys.exit(res)

if __name__ == '__main__':
    main()
