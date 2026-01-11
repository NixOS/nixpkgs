{
  lib,
  stdenv,
  symlinkJoin,
  buildGoModule,
  fetchFromGitHub,
  kubo-migrator-unwrapped,
  writeShellApplication,
  minRepoVersion ? 0, # The minimum supported Kubo repo version from which the migrations can start. Increasing this reduces the closure size
  stubBrokenMigrations ? true, # This prevents the fs-repo-migrations program from downloading binaries off the internet without even checking any signatures
}:

let
  mkMigration =
    from: to: version: hash:
    let
      pname = "fs-repo-${toString from}-to-${toString to}";
      src = fetchFromGitHub {
        owner = "ipfs";
        repo = "fs-repo-migrations";
        rev = "${pname}/v${version}";
        inherit hash;
        sparseCheckout = [ pname ];
      };
    in
    buildGoModule {
      inherit pname version src;
      sourceRoot = "${src.name}/${pname}";
      vendorHash = null;

      # Fix build on Go 1.17 and later: panic: qtls.ClientHelloInfo doesn't match
      # See https://github.com/ipfs/fs-repo-migrations/pull/163
      postPatch =
        lib.optionalString
          (lib.elem to [
            11
            12
          ])
          ''
            substituteInPlace 'vendor/github.com/marten-seemann/qtls-go1-15/common.go' \
              --replace-fail \
                '"container/list"' \
                '"container/list"
                "context"' \
              --replace-fail \
                'config *Config' \
                'config *Config
                ctx context.Context'
          '';

      checkPhase = ''
        runHook preCheck
        ${
          if to <= 11 then
            "" # Migrations fs-repo-10-to-11 and earlier require too much effort to test, making it not worth it
          else if to == 12 then
            ''
              cd migration
              go test -mod=vendor
            ''
          else if to <= 15 then
            ''
              cd not-sharness
              ./test.sh
            ''
          else
            ''
              cd test-e2e
              ./test.sh
            ''
        }
        runHook postCheck
      '';

      # Check that it does not crash
      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck
        "$out/bin/${pname}" -help
        runHook postInstallCheck
      '';

      meta = {
        inherit (kubo-migrator-unwrapped.meta)
          homepage
          license
          platforms
          maintainers
          ;
        mainProgram = pname;
        description = "Migrate the filesystem repository of Kubo from repo version ${toString from} to ${toString to}";

        broken =
          to == 7 && stdenv.hostPlatform.isDarwin # fs-repo-6-to-7 is broken on macOS: gx/ipfs/QmSGRM5Udmy1jsFBr1Cawez7Lt7LZ3ZKA23GGVEsiEW6F3/eventfd/eventfd.go:27:32: undefined: syscall.SYS_EVENTFD2
          || (lib.elem to [
            11 # fs-repo-10-to-11 fails (probably since Go 1.21) with: panic: qtls.ClientSessionState doesn't match
            12 # fs-repo-11-to-12 fails (probably since Go 1.21) with: panic: qtls.ClientSessionState doesn't match
          ]);
      };
    };

  stubBecauseDisabled =
    from: to: release:
    let
      pname = "fs-repo-${toString from}-to-${toString to}";
    in
    writeShellApplication {
      name = pname;
      text = ''
        echo 'The kubo-fs-repo-migrations package was not buit with support for ${pname}.'
        echo 'To enable support, set the minRepoVersion argument of this package to a lower value.'
        echo 'The purpose of this stub is to prevent the fs-repo-migrations program from downloading unsigned binaries from the internet.'
      '';
    };

  stubBecauseBroken =
    pname:
    writeShellApplication {
      name = pname;
      text = ''
        echo '${pname} is broken with the latest Go version.'
        echo 'The purpose of this stub is to prevent the fs-repo-migrations program from downloading unsigned binaries from the internet.'
      '';
    };

  releases = [
    {
      from = 0;
      to = 1;
      release = "1.0.1";
      hash = "sha256-2mKtr6ZXZdOOY+9GNaC85HKjOMsfeM91oxVuxHIWDO4=";
    }
    {
      from = 1;
      to = 2;
      release = "1.0.1";
      hash = "sha256-6/BewNcZc/fIBa8G1luNO2wqTdeHi8vL7ojJDjBfWYI=";
    }
    {
      from = 2;
      to = 3;
      release = "1.0.1";
      hash = "sha256-kESX/R25nb7G/uggwa7GB7I2IrdgeKe0chRzjr70Kuw=";
    }
    {
      from = 3;
      to = 4;
      release = "1.0.1";
      hash = "sha256-Mv3/7eUS8j7ZzbNR52baekDcXPwcaNpUfqkt0eRpP20=";
    }
    {
      from = 4;
      to = 5;
      release = "1.0.1";
      hash = "sha256-aEqXFhZGOBU5ql2RRqzwD5IXGySVGroaHxjrkpIGAeU=";
    }
    {
      from = 5;
      to = 6;
      release = "1.0.1";
      hash = "sha256-EhMe/3gIl3VjSh6KzBPGH4s6B3AWRnbJ+eHSc8GOHMw=";
    }
    {
      from = 6;
      to = 7;
      release = "1.0.1";
      hash = "sha256-+5kIPQZckloPujLS0QQT+ojIIndfCQaH6grftZdYQ88=";
    }
    {
      from = 7;
      to = 8;
      release = "1.0.1";
      hash = "sha256-82oSU7qhldPVTdbbol3xSnl8Ko7NUPvGpAnmFxvAceQ=";
    }
    {
      from = 8;
      to = 9;
      release = "1.0.1";
      hash = "sha256-9knC2CfiTUNJRlrOLRpKy70Hl9p9DQf6rfXnU2a0fig=";
    }
    {
      from = 9;
      to = 10;
      release = "1.0.1";
      hash = "sha256-732k76Kijs5izu404ES/YSnYfC9V88d9Qq5oHv5Qon0=";
    }
    {
      from = 10;
      to = 11;
      release = "1.0.1";
      hash = "sha256-WieBZpD8dpFDif7QxTGjRoZtNBbkI3KU4w4av7b+d4Q=";
    }
    {
      from = 11;
      to = 12;
      release = "1.0.2";
      hash = "sha256-x/4ps705Hnf+/875/tn3AsEHgaHHCc+cGXymXpRt0xA=";
    }
    {
      from = 12;
      to = 13;
      release = "1.0.0";
      hash = "sha256-HjtZ2izoZ+0BrhzXG/QJHcnwsxi0oY4Q3CHjTi29W9o=";
    }
    {
      from = 13;
      to = 14;
      release = "1.0.0";
      hash = "sha256-zvNq+AFp7HDHHZCJOh9OW/lalk3bXOl1Pi+rvJtjuSA=";
    }
    {
      from = 14;
      to = 15;
      release = "1.0.1";
      hash = "sha256-u7PM6kFCQUn07NGpeRYpBDEwc2pP+r5mf44LZU4DV5Y=";
    }
    {
      from = 15;
      to = 16;
      release = "1.0.1";
      hash = "sha256-/TG5GNSyV8gsngRT/0jazkL2n2RzA9h1gCTLqGOrI0A=";
    }
  ];

  maxRepoVersion = builtins.length releases;

  minRepoVersionValidated =
    if minRepoVersion >= 0 then
      minRepoVersion
    else
      throw "The minimum supported repo version is 0. Set `minRepoVersion` to a non-zero value.";

  latestMigration = builtins.foldl' (x: y: if y.to == maxRepoVersion then y else x) {
    release = throw "Could not get the latest Kubo migration";
  } releases;
  version = "${toString maxRepoVersion}.${latestMigration.release}";

  mkMigrationOrStub =
    x:
    let
      builder = if x.from >= minRepoVersionValidated then mkMigration else stubBecauseDisabled;
    in
    builder x.from x.to x.release x.hash;
  migrations = map mkMigrationOrStub releases;

  packageNotBroken = package: !package.meta.broken;
  migrationsBrokenRemoved = builtins.filter packageNotBroken migrations;
  migrationsBrokenStubbed = map (
    x: if packageNotBroken x then x else (stubBecauseBroken x.pname)
  ) migrations;
in

symlinkJoin {
  name = "kubo-fs-repo-migrations-${version}";
  paths = if stubBrokenMigrations then migrationsBrokenStubbed else migrationsBrokenRemoved;
  meta = (removeAttrs kubo-migrator-unwrapped.meta [ "mainProgram" ]) // {
    description = "Several individual migrations for migrating the filesystem repository of Kubo one version at a time";
    longDescription = ''
      This package contains all the individual migrations in the bin directory.
      This is used by fs-repo-migrations and could also be used by Kubo itself
      when starting it like this: `ipfs daemon --migrate`
      or when calling `ipfs repo migrate --to=16`.
    '';
  };
}
