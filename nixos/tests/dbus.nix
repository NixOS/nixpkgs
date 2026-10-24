{
  runCommand,
  evalSystem,
}:
let
  config =
    (evalSystem (
      { pkgs, ... }:
      let
        mkServices =
          name:
          pkgs.runCommand "dbus-test-${name}" { } ''
            for d in services system-services; do
              mkdir -p $out/share/dbus-1/$d
              touch $out/share/dbus-1/$d/org.nixos.test.${name}.service
            done
          '';
        registered = mkServices "Registered";
      in
      {
        boot.loader.grub.enable = false;
        fileSystems."/" = {
          device = "nodev";
          fsType = "tmpfs";
        };
        system.stateVersion = "26.11";

        environment.systemPackages = [ (mkServices "Installed") ];

        users.users.alice = {
          isNormalUser = true;
          packages = [ (mkServices "User") ];
        };

        services.dbus.packages = [
          registered
          registered
        ];
      }
    )).config;
in
runCommand "dbus-config-test"
  {
    etc = config.environment.etc."dbus-1".source;
    systemPath = config.system.path;
    userProfile = config.environment.etc."profiles/per-user/alice".source;
  }
  ''
    fail() {
      echo "$1"
      exit 1
    }

    # The system bus only reads explicit servicedirs, so only registered
    # packages may provide system services.
    dirs=$(grep --only-matching '<servicedir>[^<]*' $etc/system.conf)
    if ! grep --quiet dbus-test-Registered <<<"$dirs"; then
      fail "registered package missing in system.conf"
    fi
    if grep --quiet dbus-test-Installed <<<"$dirs"; then
      fail "unregistered package in system.conf"
    fi
    dups=$(sort <<<"$dirs" | uniq --repeated)
    if [[ -n $dups ]]; then
      fail "duplicate servicedirs in system.conf: $dups"
    fi

    # The session bus finds services through XDG_DATA_DIRS only.
    if grep --quiet '<servicedir>' $etc/session.conf; then
      fail "session.conf lists explicit servicedirs"
    fi
    if ! grep --quiet '<standard_session_servicedirs' $etc/session.conf; then
      fail "session.conf lacks standard_session_servicedirs"
    fi

    for name in Registered Installed; do
      if [[ ! -e $systemPath/share/dbus-1/services/org.nixos.test.$name.service ]]; then
        fail "session service of $name missing from the system profile"
      fi
    done
    if [[ ! -e $userProfile/share/dbus-1/services/org.nixos.test.User.service ]]; then
      fail "session service missing from the per-user profile"
    fi

    touch $out
  ''
