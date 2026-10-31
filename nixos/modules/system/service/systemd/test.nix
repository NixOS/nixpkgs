# Run:
#   nix-build -A nixosTests.modularService

{
  evalSystem,
  runCommand,
  hello,
  lib,
  ...
}:

let
  machine = evalSystem (
    { lib, ... }:
    let
      hello' = lib.getExe hello;

      # A composite module written once, imported at two different attribute
      # paths: each instance resolves to its own tree's anchor.
      reusableComposite =
        { config, ... }:
        {
          process.argv = [ hello' ];
          identity.sameUser = config.services.anchor;
          services.anchor = {
            process.argv = [ hello' ];
            identity.user = "reusable-anchor";
          };
          services.worker = {
            process.argv = [ hello' ];
            identity.sameUser = config.services.anchor;
          };
        };
    in
    {

      # Test input

      system.services.foo = {
        process = {
          argv = [
            hello'
            "--greeting"
            "hoi"
          ];
        };
      };
      system.services.bar = {
        process = {
          argv = [
            hello'
            "--greeting"
            "hoi"
          ];
        };
        systemd.service = {
          serviceConfig.X-Bar = "lol crossbar whatever";
        };
        services.db = {
          process = {
            argv = [
              hello'
              "--greeting"
              "Hi, I'm a database, would you believe it"
            ];
          };
          systemd.service = {
            serviceConfig.RestartSec = "42";
          };
        };
      };

      # Test that systemd.mainExecStart overrides process.argv
      # and allows systemd's specifier and variable substitution
      system.services.argv-with-subst = {
        process = {
          argv = [
            hello'
            "--greeting"
            "This should be ignored"
          ];
        };
        systemd.mainExecStart = ''/bin/sh -c "echo %n and ''${HOME}"'';
      };

      # Test that process.argv escapes % and $ by default
      system.services.argv-escaped = {
        process = {
          argv = [
            "/bin/sh"
            "-c"
            "echo %n and \${HOME}"
          ];
        };
      };

      # Test extending process.argv with systemd specifiers
      system.services.argv-extended =
        { config, ... }:
        {
          process = {
            argv = [
              hello'
              "--greeting"
              "Fun $1 fact, remainder is often expressed as m%n"
            ];
          };
          systemd.mainExecStart =
            config.systemd.lib.escapeSystemdExecArgs config.process.argv + " --systemd-unit %n";
        };

      # Identity use cases, see ./identity.nix and
      # https://github.com/NixOS/nixpkgs/issues/545287

      # Nothing specified: the service gets a user derived from its attribute
      # path, with its primary group, and the uid left to activation.
      system.services.identity-default = {
        process.argv = [ hello' ];
      };

      # User name specified, uid left to activation.
      system.services.identity-named = {
        process.argv = [ hello' ];
        identity.user = "named-account";
      };

      # Only the uid pinned, the name is derived from the attribute path.
      system.services.identity-uid-only = {
        process.argv = [ hello' ];
        identity.uid = 1530;
      };

      # Everything pinned down: user, uid, group, gid and a supplementary
      # group with its gid.
      system.services.identity-pinned = {
        process.argv = [ hello' ];
        identity = {
          user = "pinned-account";
          uid = 1520;
          group = "pinned-group";
          gid = 1521;
          groups = [ "pinned-supp" ];
          gids = [ 1522 ];
        };
      };

      # Same-user constraints without pinning names or ids: anchor the user on
      # a sub-service and reference it. `web` references the `v2` sub-service
      # of its `api` sibling. References use service configuration *handles*,
      # which work regardless of where a composite module is imported.
      system.services.identity-composition = { config, ... }: {
        process.argv = [ hello' ];
        identity.sameUser = config.services.anchor;
        services.anchor = {
          process.argv = [ hello' ];
          identity.user = "anchor-account";
        };
        services.api = {
          process.argv = [ hello' ];
          services.v2 = {
            process.argv = [ hello' ];
            identity.user = "api-v2-account";
          };
        };
        services.web = {
          process.argv = [ hello' ];
          identity.sameUser = config.services.api.services.v2;
        };
      };

      system.services.reusable-1.imports = [ reusableComposite ];
      system.services.reusable-2.imports = [ reusableComposite ];

      # irrelevant stuff
      system.stateVersion = "25.05";
      fileSystems."/" = {
        device = "/test/dummy";
        fsType = "auto";
      };
      boot.loader.grub.enable = false;
    }
  );

  inherit (machine.config.system.build) toplevel;

  # Identity checks, see ./identity.nix.
  identityUsers = machine.config.users.users;
  identityGroups = machine.config.users.groups;
  identityUnit = name: machine.config.systemd.services."${name}".serviceConfig;

  # Simulated platform without user support (like a process manager that
  # cannot map users): all identity values resolve to null, even requests.
  walklib = import ./identity.nix { inherit lib; };
  noUsersConfigured = lib.services.configure {
    serviceManagerPkgs = { };
    extraRootModules = [
      (walklib.mkIdentityModule {
        supported = false;
        path = [ ];
      })
    ];
  };
  supportedConfigured = lib.services.configure {
    serviceManagerPkgs = { };
    extraRootModules = [
      (walklib.mkIdentityModule {
        supported = true;
        path = [ ];
      })
    ];
  };
  identityEval =
    cfg-chunk:
    lib.evalModules {
      modules = [
        {
          options.testServices = lib.mkOption {
            type = lib.types.attrsOf noUsersConfigured.serviceSubmodule;
          };
        }
        cfg-chunk
      ];
    };
  supportedEval =
    cfg-chunk:
    lib.evalModules {
      modules = [
        {
          options.testServices = lib.mkOption {
            type = lib.types.attrsOf supportedConfigured.serviceSubmodule;
          };
        }
        cfg-chunk
      ];
    };
  # Validate the identity interface in diverse scenarios: the portable
  # interface plus ./identity.nix, without NixOS, to check the resolution
  # rules directly.
  scenarioChecks =
    map
      (c: {
        name = c.name;
        holds = (builtins.tryEval c.v).success && c.v;
      })
      [
        # Derived user name from the attribute path.
        {
          name = "scenario-derived-user";
          v =
            let
              id = (supportedEval { testServices.from-path = { }; }).config.testServices.from-path.identity;
            in
            id.user == "svc-from-path" && id.group == "svc-from-path" && id.uid == null && id.groups == [ ];
        }
        {
          name = "scenario-named-user";
          v =
            (supportedEval { testServices.named.identity.user = "uno"; })
            .config.testServices.named.identity.user == "uno";
        }
        # Referencing the parent service via a handle.
        {
          name = "scenario-parent-handle";
          v =
            let
              id =
                (supportedEval (
                  { config, ... }:
                  {
                    testServices.app.identity.user = "sha";
                    testServices.app.services.web.identity.sameUser = config.testServices.app;
                  }
                )).config.testServices.app.services.web.identity;
            in
            id.user == "sha" && id.group == "sha" && id.uid == null;
        }
        # Referencing a sibling sub-service via a handle.
        {
          name = "scenario-sibling-handle";
          v =
            let
              id =
                (supportedEval (
                  { config, ... }:
                  {
                    testServices.app.services.worker.identity.user = "worker-aaa";
                    testServices.app.services.web.identity.sameUser = config.testServices.app.services.worker;
                  }
                )).config.testServices.app.services.web.identity;
            in
            id.user == "worker-aaa" && id.group == "worker-aaa";
        }
        # Unsupported platform: all identity values resolve to null, even requests.
        {
          name = "scenario-unsupported-null";
          v =
            (identityEval {
              testServices.a.identity.user = "rfc";
              testServices.a.identity.uid = 1234;
            }).config.testServices.a.identity == {
              user = null;
              uid = null;
              group = null;
              gid = null;
              groups = null;
              gids = null;
              sameUser = null;
            };
        }
        # The reference type rejects values without an `absoluteServicePath` tag.
        {
          name = "scenario-not-handle-errors";
          v =
            (builtins.tryEval
              (supportedEval {
                testServices.a.identity.sameUser = {
                  user = "nothandle";
                };
              }).config.testServices.a.identity.sameUser
            ).success == false;
        }
        # The built-in `absoluteServicePath` is read-only.
        {
          name = "scenario-absolute-service-path-read-only-errors";
          v =
            (builtins.tryEval
              (supportedEval { testServices.a.absoluteServicePath = [ "forged" ]; })
              .config.testServices.a.absoluteServicePath
            ).success == false;
        }
        # A derived user name beyond the 31-character limit is rejected.
        {
          name = "scenario-derived-user-too-long-errors";
          v =
            (builtins.tryEval
              (supportedEval { testServices."aaaaaaaaaaaaaaaaaaaaaaaaaaaa" = { }; })
              .config.testServices."aaaaaaaaaaaaaaaaaaaaaaaaaaaa".identity.user
            ).success == false;
        }
        # `gids` without `groups` fails the pairing assertion; collected, not thrown.
        {
          name = "scenario-gids-only-assertion";
          v =
            let
              assertions =
                lib.services.getAssertions [ "a" ]
                  (supportedEval {
                    testServices.a.identity.gids = [ 1522 ];
                  }).config.testServices.a;
            in
            lib.filter (ass: !ass.assertion) assertions != [ ];
        }
      ];

  # Identity checks. Values are read lazily and checked below; the failure
  # report lists every violated check.
  identityChecks =
    map
      (c: {
        name = c.name;
        holds = (builtins.tryEval c.v).success && c.v;
      })
      [
        {
          name = "default-user-exists";
          v = identityUsers ? "svc-identity-default";
        }
        {
          name = "default-user-uid-idless";
          v = identityUsers.svc-identity-default.uid == null;
        }
        {
          name = "default-user-private-group";
          v = identityUsers.svc-identity-default.group == "svc-identity-default";
        }
        {
          name = "default-user-is-system";
          v = identityUsers.svc-identity-default.isSystemUser == true;
        }
        {
          name = "named-user-exists";
          v = identityUsers ? "named-account";
        }
        {
          name = "named-user-uid-idless";
          v = identityUsers.named-account.uid == null;
        }
        {
          name = "named-user-group";
          v = identityUsers.named-account.group == "named-account";
        }
        {
          name = "uid-only-user-exists";
          v = identityUsers ? "svc-identity-uid-only";
        }
        {
          name = "uid-only-pinned";
          v = identityUsers.svc-identity-uid-only.uid == 1530;
        }
        {
          name = "uid-only-private-group";
          v = identityUsers.svc-identity-uid-only.group == "svc-identity-uid-only";
        }
        {
          name = "pinned-uid";
          v = identityUsers.pinned-account.uid == 1520;
        }
        {
          name = "pinned-group";
          v = identityUsers.pinned-account.group == "pinned-group";
        }
        {
          name = "pinned-extra-groups";
          v = identityUsers.pinned-account.extraGroups == [ "pinned-supp" ];
        }
        {
          name = "pinned-is-system";
          v = identityUsers.pinned-account.isSystemUser == true;
        }
        {
          name = "pinned-group-gid";
          v = identityGroups.pinned-group.gid == 1521;
        }
        {
          name = "pinned-supp-gid";
          v = identityGroups.pinned-supp.gid == 1522;
        }
        {
          name = "anchor-user-exists";
          v = identityUsers ? "anchor-account";
        }
        {
          name = "api-v2-user-exists";
          v = identityUsers ? "api-v2-account";
        }
        {
          name = "no-derived-composition-user";
          v = !(identityUsers ? "svc-identity-composition");
        }
        {
          name = "no-derived-web-user";
          v = !(identityUsers ? "svc-identity-composition-web");
        }
        {
          name = "no-derived-named-user";
          v = !(identityUsers ? "svc-identity-named");
        }
        {
          name = "no-derived-apiv2-user";
          v = !(identityUsers ? "svc-identity-composition-api-v2");
        }
        {
          name = "reusable-anchor-exists";
          v = identityUsers ? "reusable-anchor";
        }
        # Both composite instances resolve to their own tree's anchor user.
        {
          name = "no-derived-reusable-users";
          v = !(identityUsers ? "svc-reusable-1") && !(identityUsers ? "svc-reusable-2");
        }

        # The built-in absoluteServicePath handles.
        {
          name = "path-of-top-level";
          v =
            machine.config.system.services.identity-composition.absoluteServicePath
            == [ "identity-composition" ];
        }
        {
          name = "path-of-subservice";
          v =
            machine.config.system.services.identity-composition.services.anchor.absoluteServicePath == [
              "identity-composition"
              "anchor"
            ];
        }
        {
          name = "path-of-reusable-anchor";
          v =
            machine.config.system.services."reusable-1".services.anchor.absoluteServicePath == [
              "reusable-1"
              "anchor"
            ];
        }
      ];

  unitText = name: machine.config.systemd.units."${name}.service".text;

  unitTextChecks =
    map
      (c: {
        name = c.name;
        holds = (builtins.tryEval c.v).success && c.v;
      })
      [
        {
          name = "text-default-user";
          v = builtins.match ".*User=svc-identity-default.*" (unitText "identity-default") != null;
        }
        {
          name = "text-default-group";
          v = builtins.match ".*Group=svc-identity-default.*" (unitText "identity-default") != null;
        }
        {
          name = "text-named-user";
          v = builtins.match ".*User=named-account.*" (unitText "identity-named") != null;
        }
        {
          name = "text-uid-only-user";
          v = builtins.match ".*User=svc-identity-uid-only.*" (unitText "identity-uid-only") != null;
        }
        {
          name = "text-pinned-user";
          v = builtins.match ".*User=pinned-account.*" (unitText "identity-pinned") != null;
        }
        {
          name = "text-pinned-group";
          v = builtins.match ".*Group=pinned-group.*" (unitText "identity-pinned") != null;
        }
        {
          name = "text-pinned-supp";
          v = builtins.match ".*SupplementaryGroups=pinned-supp.*" (unitText "identity-pinned") != null;
        }
        {
          name = "text-composition-user";
          v = builtins.match ".*User=anchor-account.*" (unitText "identity-composition") != null;
        }
        {
          name = "text-anchor-user";
          v = builtins.match ".*User=anchor-account.*" (unitText "identity-composition-anchor") != null;
        }
        {
          name = "text-apiv2-user";
          v = builtins.match ".*User=api-v2-account.*" (unitText "identity-composition-api-v2") != null;
        }
        {
          name = "text-web-user";
          v = builtins.match ".*User=api-v2-account.*" (unitText "identity-composition-web") != null;
        }
        {
          name = "text-reuse1-composite";
          v = builtins.match ".*User=reusable-anchor.*" (unitText "reusable-1") != null;
        }
        {
          name = "text-reuse1-anchor";
          v = builtins.match ".*User=reusable-anchor.*" (unitText "reusable-1-anchor") != null;
        }
        {
          name = "text-reuse1-worker";
          v = builtins.match ".*User=reusable-anchor.*" (unitText "reusable-1-worker") != null;
        }
        {
          name = "text-reuse2-worker";
          v = builtins.match ".*User=reusable-anchor.*" (unitText "reusable-2-worker") != null;
        }
      ];

  unitChecks =
    map
      (c: {
        name = c.name;
        holds = (builtins.tryEval c.v).success && c.v;
      })
      [
        {
          name = "unit-default-user";
          v = (identityUnit "identity-default").User == "svc-identity-default";
        }
        {
          name = "unit-default-group";
          v = (identityUnit "identity-default").Group == "svc-identity-default";
        }
        {
          name = "unit-named-user";
          v = (identityUnit "identity-named").User == "named-account";
        }
        {
          name = "unit-uid-only-user";
          v = (identityUnit "identity-uid-only").User == "svc-identity-uid-only";
        }
        {
          name = "unit-pinned-user";
          v = (identityUnit "identity-pinned").User == "pinned-account";
        }
        {
          name = "unit-pinned-group";
          v = (identityUnit "identity-pinned").Group == "pinned-group";
        }
        {
          name = "unit-pinned-supp";
          v = (identityUnit "identity-pinned").SupplementaryGroups == [ "pinned-supp" ];
        }
        {
          name = "unit-composition-user";
          v = (identityUnit "identity-composition").User == "anchor-account";
        }
        {
          name = "unit-anchor-user";
          v = (identityUnit "identity-composition-anchor").User == "anchor-account";
        }
        {
          name = "unit-apiv2-user";
          v = (identityUnit "identity-composition-api-v2").User == "api-v2-account";
        }
        {
          name = "unit-web-user";
          v = (identityUnit "identity-composition-web").User == "api-v2-account";
        }
        # Both instances of the reusable composite resolve to their own anchor.
        {
          name = "unit-reuse1-composite";
          v = (identityUnit "reusable-1").User == "reusable-anchor";
        }
        {
          name = "unit-reuse1-anchor";
          v = (identityUnit "reusable-1-anchor").User == "reusable-anchor";
        }
        {
          name = "unit-reuse1-worker";
          v = (identityUnit "reusable-1-worker").User == "reusable-anchor";
        }
        {
          name = "unit-reuse2-worker";
          v = (identityUnit "reusable-2-worker").User == "reusable-anchor";
        }
      ];

  failedChecks = map (c: c.name) (
    lib.filter (c: !c.holds) (identityChecks ++ unitChecks ++ unitTextChecks ++ scenarioChecks)
  );
in
assert lib.throwIf (failedChecks != [ ]) (
  "modular services identity: failed checks: " + lib.concatStringsSep ", " failedChecks
) true;
runCommand "test-modular-service-systemd-units"
  {
    passthru = {
      inherit
        machine
        toplevel
        ;
    };
  }
  ''
    echo ${toplevel}/etc/systemd/system/foo.service:
    cat -n ${toplevel}/etc/systemd/system/foo.service
    (
      set -x
      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "hoi"' ${toplevel}/etc/systemd/system/foo.service >/dev/null

      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "hoi"' ${toplevel}/etc/systemd/system/bar.service >/dev/null
      grep -F 'X-Bar=lol crossbar whatever' ${toplevel}/etc/systemd/system/bar.service >/dev/null

      grep    'ExecStart="${hello}/bin/hello" "--greeting" ".*database.*"' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null
      grep -F 'RestartSec=42' ${toplevel}/etc/systemd/system/bar-db.service >/dev/null

      # Test that systemd.mainExecStart overrides process.argv
      # Note: %n and $HOME are NOT escaped, allowing systemd to substitute them
      grep -F 'ExecStart=/bin/sh -c "echo %n and ''${HOME}"' ${toplevel}/etc/systemd/system/argv-with-subst.service >/dev/null

      # Test that process.argv escapes % as %% and $ as $$
      # This prevents systemd from performing specifier/variable substitution
      grep -F 'ExecStart="/bin/sh" "-c" "echo %%n and $${HOME}"' ${toplevel}/etc/systemd/system/argv-escaped.service >/dev/null

      # Test extending process.argv with systemd specifiers
      # The base command should be escaped ($1 -> $$1, m%n -> m%%n), but the appended --systemd-unit %n should not be
      grep -F 'ExecStart="${hello}/bin/hello" "--greeting" "Fun $$1 fact, remainder is often expressed as m%%n" --systemd-unit %n' ${toplevel}/etc/systemd/system/argv-extended.service >/dev/null

      [[ ! -e ${toplevel}/etc/systemd/system/foo.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar.socket ]]
      [[ ! -e ${toplevel}/etc/systemd/system/bar-db.socket ]]

      # Identity: services run as the resolved user/group.
      grep -F 'User=svc-identity-default' ${toplevel}/etc/systemd/system/identity-default.service >/dev/null
      grep -F 'Group=svc-identity-default' ${toplevel}/etc/systemd/system/identity-default.service >/dev/null
      grep -F 'User=named-account' ${toplevel}/etc/systemd/system/identity-named.service >/dev/null
      grep -F 'User=svc-identity-uid-only' ${toplevel}/etc/systemd/system/identity-uid-only.service >/dev/null
      grep -F 'User=pinned-account' ${toplevel}/etc/systemd/system/identity-pinned.service >/dev/null
      grep -F 'Group=pinned-group' ${toplevel}/etc/systemd/system/identity-pinned.service >/dev/null
      grep -F 'SupplementaryGroups=pinned-supp' ${toplevel}/etc/systemd/system/identity-pinned.service >/dev/null
      grep -F 'User=anchor-account' ${toplevel}/etc/systemd/system/identity-composition.service >/dev/null
      grep -F 'User=anchor-account' ${toplevel}/etc/systemd/system/identity-composition-anchor.service >/dev/null
      grep -F 'Group=anchor-account' ${toplevel}/etc/systemd/system/identity-composition-anchor.service >/dev/null
      grep -F 'User=api-v2-account' ${toplevel}/etc/systemd/system/identity-composition-api-v2.service >/dev/null
      grep -F 'User=api-v2-account' ${toplevel}/etc/systemd/system/identity-composition-web.service >/dev/null
      # Both instances of the reusable composite share their own tree's anchor.
      grep -F 'User=reusable-anchor' ${toplevel}/etc/systemd/system/reusable-1.service >/dev/null
      grep -F 'User=reusable-anchor' ${toplevel}/etc/systemd/system/reusable-1-anchor.service >/dev/null
      grep -F 'User=reusable-anchor' ${toplevel}/etc/systemd/system/reusable-1-worker.service >/dev/null
      grep -F 'User=reusable-anchor' ${toplevel}/etc/systemd/system/reusable-2-worker.service >/dev/null
    )
    echo 🐬👍
    touch $out
  ''
