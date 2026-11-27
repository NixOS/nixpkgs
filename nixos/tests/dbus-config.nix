{
  runCommand,
  evalSystem,
}:
let
  config =
    (evalSystem (
      { lib, pkgs, ... }:
      let
        mkServices =
          name:
          pkgs.runCommand "dbus-test-${name}" { } ''
            for d in services system-services; do
              mkdir -p $out/share/dbus-1/$d
              touch $out/share/dbus-1/$d/org.nixos.test.${name}.service
            done
            # Legacy location of system policies.
            mkdir -p $out/etc/dbus-1/system.d
            touch $out/etc/dbus-1/system.d/org.nixos.test.${name}.conf
            mkdir -p $out/bin
            touch $out/bin/dbus-test-${name}
          '';
        registered = mkServices "Registered";
      in
      {
        boot.loader.grub.enable = false;
        fileSystems."/" = {
          device = "nodev";
          fsType = "tmpfs";
        };
        system.stateVersion = lib.trivial.release;

        environment.systemPackages = [ (mkServices "Installed") ];

        users.users.alice = {
          isNormalUser = true;
          packages = [ (mkServices "User") ];
        };

        # As if registered by two modules.
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

    # The system bus only reads the system profile.
    dirs=$(grep --only-matching --perl-regexp '<servicedir>\K[^<]*' $etc/system.conf)
    if [[ $dirs != "$systemPath/share/dbus-1/system-services" ]]; then
      fail "expected only the system profile as servicedir in system.conf, got: $dirs"
    fi
    if ! grep --quiet "<includedir>$systemPath/etc/dbus-1/system.d</includedir>" $etc/system.conf; then
      fail "system.conf does not include etc/dbus-1/system.d of the system profile"
    fi
    for name in Registered Installed; do
      if [[ ! -e $dirs/org.nixos.test.$name.service ]]; then
        fail "system service of $name missing in $dirs"
      fi
      if [[ ! -e $systemPath/etc/dbus-1/system.d/org.nixos.test.$name.conf ]]; then
        fail "etc/dbus-1/system.d policy of $name missing from the system profile"
      fi
    done
    if [[ -e $dirs/org.nixos.test.User.service ]]; then
      fail "system service of a user package in $dirs"
    fi

    # Registered packages don't get their binaries installed.
    if [[ -e $systemPath/bin/dbus-test-Registered ]]; then
      fail "binary of the registered package in the system profile"
    fi

    # The session bus finds services through XDG_DATA_DIRS only.
    if grep --quiet '<servicedir>' $etc/session.conf; then
      fail "session.conf lists explicit servicedirs"
    fi
    if ! grep --quiet '<standard_session_servicedirs' $etc/session.conf; then
      fail "session.conf lacks standard_session_servicedirs"
    fi
    includes=$(grep --only-matching --perl-regexp '<includedir>\K[^<]*' $etc/session.conf)
    if [[ $includes != "$systemPath/share/dbus-1/session.d" ]]; then
      fail "expected only the system profile as includedir in session.conf, got: $includes"
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
