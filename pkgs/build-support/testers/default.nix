{ pkgs, pkgsLinux, buildPackages, lib, callPackage, runCommand, stdenv, substituteAll, testers }:
# Documentation is in doc/builders/testers.chapter.md
{
  # See https://nixos.org/manual/nixpkgs/unstable/#tester-lycheeLinkCheck
  # or doc/builders/testers.chapter.md
  inherit (callPackage ./lychee.nix {}) lycheeLinkCheck;

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-testBuildFailure
  # or doc/builders/testers.chapter.md
  testBuildFailure = drv: drv.overrideAttrs (orig: {
    builder = buildPackages.bash;
    args = [
      (substituteAll { coreutils = buildPackages.coreutils; src = ./expect-failure.sh; })
      orig.realBuilder or stdenv.shell
    ] ++ orig.args or ["-e" (orig.builder or ../../stdenv/generic/default-builder.sh)];
  });

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-testEqualDerivation
  # or doc/builders/testers.chapter.md
  testEqualDerivation = callPackage ./test-equal-derivation.nix { };

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-testEqualContents
  # or doc/builders/testers.chapter.md
  testEqualContents = {
    assertion,
    actual,
    expected,
  }: runCommand "equal-contents-${lib.strings.toLower assertion}" {
    inherit assertion actual expected;
  } ''
    echo "Checking:"
    echo "$assertion"
    if ! diff -U5 -r "$actual" "$expected" --color=always
    then
      echo
      echo 'Contents must be equal, but were not!'
      echo
      echo "+: expected,   at $expected"
      echo "-: unexpected, at $actual"
      exit 1
    else
      find "$expected" -type f -executable > expected-executables | sort
      find "$actual" -type f -executable > actual-executables | sort
      if ! diff -U0 actual-executables expected-executables --color=always
      then
        echo
        echo "Contents must be equal, but some files' executable bits don't match"
        echo
        echo "+: make this file executable in the actual contents"
        echo "-: make this file non-executable in the actual contents"
        exit 1
      else
        echo "expected $expected and actual $actual match."
        echo 'OK'
        touch $out
      fi
    fi
  '';

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-testVersion
  # or doc/builders/testers.chapter.md
  testVersion =
    { package,
      command ? "${package.meta.mainProgram or package.pname or package.name} --version",
      version ? package.version,
    }: runCommand "${package.name}-test-version" { nativeBuildInputs = [ package ]; meta.timeout = 60; } ''
      if output=$(${command} 2>&1); then
        if grep -Fw -- "${version}" - <<< "$output"; then
          touch $out
        else
          echo "Version string '${version}' not found!" >&2
          echo "The output was:" >&2
          echo "$output" >&2
          exit 1
        fi
      else
        echo -n ${lib.escapeShellArg command} >&2
        echo " returned a non-zero exit code." >&2
        echo "$output" >&2
        exit 1
      fi
    '';

  # See doc/builders/testers.chapter.md or
  # https://nixos.org/manual/nixpkgs/unstable/#tester-invalidateFetcherByDrvHash
  invalidateFetcherByDrvHash = f: args:
    let
      drvPath = (f args).drvPath;
      # It's safe to discard the context, because we don't access the path.
      salt = builtins.unsafeDiscardStringContext (lib.substring 0 12 (baseNameOf drvPath));
      # New derivation incorporating the original drv hash in the name
      salted = f (args // { name = "${args.name or "source"}-salted-${salt}"; });
      # Make sure we did change the derivation. If the fetcher ignores `name`,
      # `invalidateFetcherByDrvHash` doesn't work.
      checked =
        if salted.drvPath == drvPath
        then throw "invalidateFetcherByDrvHash: Adding the derivation hash to the fixed-output derivation name had no effect. Make sure the fetcher's name argument ends up in the derivation name. Otherwise, the fetcher will not be re-run when its implementation changes. This is important for testing."
        else salted;
    in checked;

  # See doc/builders/testers.chapter.md or
  # https://nixos.org/manual/nixpkgs/unstable/#tester-runNixOSTest
  runNixOSTest =
    let nixos = import ../../../nixos/lib {
      inherit lib;
    };
    in testModule:
        nixos.runTest {
          _file = "pkgs.runNixOSTest implementation";
          imports = [
            (lib.setDefaultModuleLocation "the argument that was passed to pkgs.runNixOSTest" testModule)
          ];
          hostPkgs = pkgs;
          node.pkgs = pkgsLinux;
        };

  # See doc/builders/testers.chapter.md or
  # https://nixos.org/manual/nixpkgs/unstable/#tester-invalidateFetcherByDrvHash
  nixosTest =
    let
      /* The nixos/lib/testing-python.nix module, preapplied with arguments that
       * make sense for this evaluation of Nixpkgs.
       */
      nixosTesting =
        (import ../../../nixos/lib/testing-python.nix {
          inherit (stdenv.hostPlatform) system;
          inherit pkgs;
          extraConfigurations = [(
            { lib, ... }: {
              config.nixpkgs.pkgs = lib.mkDefault pkgsLinux;
            }
          )];
        });
    in
      test:
        let
          loadedTest = if builtins.typeOf test == "path"
            then import test
            else test;
          calledTest = lib.toFunction loadedTest pkgs;
        in
          nixosTesting.simpleTest calledTest;

  hasPkgConfigModule =
    { moduleName, ... }@args:
    lib.warn "testers.hasPkgConfigModule has been deprecated in favor of testers.hasPkgConfigModules. It accepts a list of strings via the moduleNames argument instead of a single moduleName." (
      testers.hasPkgConfigModules (builtins.removeAttrs args [ "moduleName" ] // {
        moduleNames = [ moduleName ];
      })
    );
  hasPkgConfigModules = callPackage ./hasPkgConfigModules/tester.nix { };

  testMetaPkgConfig = callPackage ./testMetaPkgConfig/tester.nix { };
}
