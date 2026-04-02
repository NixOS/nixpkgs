{ lib, pkgs, ... }:
let
  nodeNames = [
    "a"
    "b"
    "c"
  ];
  nodeDirs = lib.genAttrs nodeNames (n: ./test-nodes + "/${n}");
  nodeData = lib.mapAttrs (n: v: {
    cert = "${v}/cert.pem";
    key = "${v}/key.pem";
    id = lib.fileContents (v + "/id");
  }) nodeDirs;

  testPassword = "it's a secret";

  commonNodeConfigModule = {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      settings.devices = lib.mapAttrs (n: v: { inherit (v) id; }) nodeData;
    };
  };

  nodeConfigModules = {
    a = {
      services.syncthing = { inherit (nodeData.a) cert key; };
    };
    b = {
      services.syncthing = { inherit (nodeData.b) cert key; };
    };
    c = {
      services.syncthing = { inherit (nodeData.c) cert key; };
    };
  };

  nodeFolderConfigModules = [
    # "foo" is a folder that is synchronised only between nodes a and b.
    rec {
      a = {
        services.syncthing.settings.folders.foo = {
          path = "/var/lib/syncthing/foo";
          devices = [
            "a"
            "b"
          ];
        };
      };

      b = a;

      c = { };
    }

    # "bar" is synchronised between a and c, and between b and c, but c only
    # gets an encrypted copy, and a and b never synchronise directly to each
    # other.
    rec {
      a =
        { config, ... }:
        {
          environment.etc.bar-encryption-password.text = testPassword;

          services.syncthing.settings.folders.bar = {
            path = "/var/lib/syncthing/bar";
            devices = [
              {
                name = "c";
                encryptionPasswordFile = "/etc/${config.environment.etc.bar-encryption-password.target}";
              }
            ];
          };
        };

      b = a;

      c = {
        services.syncthing.settings.folders.bar = {
          path = "/var/lib/syncthing/bar";
          devices = [
            "a"
            "b"
          ];
          type = "receiveencrypted";
        };
      };
    }

    # "baz" is synchronised between all three nodes, but has filters on b and c
    # that mean they shouldn't receive certain files.
    {
      a = {
        services.syncthing.settings.folders.baz = {
          path = "/var/lib/syncthing/baz";
          devices = [
            "b"
            "c"
          ];
          ignorePatterns = [ ];
        };
      };

      b = {
        services.syncthing.settings.folders.baz = {
          path = "/var/lib/syncthing/baz";
          devices = [
            "a"
            "c"
          ];
          ignorePatterns = [ "notB" ];
        };
      };

      c = {
        services.syncthing.settings.folders.baz = {
          path = "/var/lib/syncthing/baz";
          devices = [
            "a"
            "b"
          ];
          ignorePatterns = [ "notC" ];
        };
      };
    }

    # "foo bar" tests handling whitespace in folder IDs.
    {
      a = {
        services.syncthing.settings.folders."foo bar" = {
          path = "/var/lib/syncthing/foo-bar";
          devices = [ "b" ];
        };
      };

      b = {
        services.syncthing.settings.folders."foo bar" = {
          path = "/var/lib/syncthing/foo-bar";
          devices = [ "a" ];
          ignorePatterns = [ "notB" ];
        };
      };

      c = { };
    }
  ];
in
{
  name = "syncthing";
  meta.maintainers = with pkgs.lib.maintainers; [ zarelit ];

  # Run from the root of the nixpkgs repository with
  #
  #     nix-build -A nixosTests.syncthing-folders.genNodeIds &&
  #       ./result/bin/genNodeIds.sh
  passthru.genNodeIds = pkgs.writeShellApplication {
    name = "genNodeIds.sh";
    runtimeInputs = with pkgs; [
      syncthing
      libxml2
    ];
    text = ''
      rm -r nixos/tests/syncthing/test-nodes
      mkdir nixos/tests/syncthing/test-nodes
      cd nixos/tests/syncthing/test-nodes

      for d in ${lib.escapeShellArgs nodeNames}; do
        mkdir -- "$d"
        syncthing generate --home="$d"
        xmllint --xpath 'string(configuration/device/@id)' "$d"/config.xml >"$d"/id
        rm -f -- "$d"/.syncthing.tmp.* "$d"/config.xml
      done
    '';
  };

  nodes = lib.genAttrs nodeNames (n: {
    imports = [
      commonNodeConfigModule
      nodeConfigModules."${n}"
    ]
    ++ builtins.map (builtins.getAttr n) nodeFolderConfigModules;
  });

  testScript = ''
    start_all()

    a.wait_for_unit("syncthing.service")
    b.wait_for_unit("syncthing.service")
    c.wait_for_unit("syncthing.service")
    a.wait_for_open_port(22000)
    b.wait_for_open_port(22000)
    c.wait_for_open_port(22000)

    # Test foo

    a.wait_for_file("/var/lib/syncthing/foo")
    b.wait_for_file("/var/lib/syncthing/foo")

    a.succeed("echo a2b > /var/lib/syncthing/foo/a2b")
    b.succeed("echo b2a > /var/lib/syncthing/foo/b2a")

    a.wait_for_file("/var/lib/syncthing/foo/b2a")
    b.wait_for_file("/var/lib/syncthing/foo/a2b")

    # Test bar

    a.wait_for_file("/var/lib/syncthing/bar")
    b.wait_for_file("/var/lib/syncthing/bar")
    c.wait_for_file("/var/lib/syncthing/bar")

    a.succeed("echo plaincontent > /var/lib/syncthing/bar/plainname")

    # B should be able to decrypt, check that content of file matches
    b.wait_for_file("/var/lib/syncthing/bar/plainname")
    file_contents = b.succeed("cat /var/lib/syncthing/bar/plainname")
    assert "plaincontent\n" == file_contents, f"Unexpected file contents: {file_contents=}"

    # Bar on C is untrusted, check that content is not in cleartext
    c.fail("grep -R plaincontent /var/lib/syncthing/bar")

    # Test baz

    a.wait_for_file("/var/lib/syncthing/baz")
    b.wait_for_file("/var/lib/syncthing/baz")
    c.wait_for_file("/var/lib/syncthing/baz")

    # A creates the file notB, C should get it, B should ignore it
    a.succeed("echo notB > /var/lib/syncthing/baz/notB")
    a.succeed("echo controlA > /var/lib/syncthing/baz/controlA")
    c.wait_for_file("/var/lib/syncthing/baz/notB")
    c.wait_for_file("/var/lib/syncthing/baz/controlA")
    b.wait_for_file("/var/lib/syncthing/baz/controlA")

    # B creates the file notC, A should get it, C should ignore it
    b.succeed("echo notC > /var/lib/syncthing/baz/notC")
    b.succeed("echo controlB > /var/lib/syncthing/baz/controlB")
    a.wait_for_file("/var/lib/syncthing/baz/notC")
    a.wait_for_file("/var/lib/syncthing/baz/controlB")
    c.wait_for_file("/var/lib/syncthing/baz/controlB")

    # Check that files have been correctly ignored
    b.fail("cat /var/lib/syncthing/baz/notB")
    c.fail("cat /var/lib/syncthing/baz/notC")

    # Test foo bar

    a.wait_for_file("/var/lib/syncthing/foo-bar")
    b.wait_for_file("/var/lib/syncthing/foo-bar")

    a.succeed("echo a2b > /var/lib/syncthing/foo-bar/a2b")
    a.succeed("echo a2b > /var/lib/syncthing/foo-bar/notB")
    b.succeed("echo b2a > /var/lib/syncthing/foo-bar/b2a")

    a.wait_for_file("/var/lib/syncthing/foo-bar/b2a")
    b.wait_for_file("/var/lib/syncthing/foo-bar/a2b")

    # Check that file has been correctly ignored
    b.fail("cat /var/lib/syncthing/foo-bar/notB")
  '';
}
