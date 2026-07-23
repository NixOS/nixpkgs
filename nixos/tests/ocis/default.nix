{
  evalSystem,
  pkgs,
  runTest,
}:

let
  inherit (pkgs) lib;

  packageNames = [
    "ocis_5-bin"
    "ocis_70-bin"
    "ocis_71-bin"
    "ocis_72-bin"
    "ocis_73-bin"
    "ocis_80-bin"
    "ocis_81-bin"
  ];

  newPackageNames = lib.remove "ocis_5-bin" packageNames;

  supportedSystems = [
    "aarch64-darwin"
    "aarch64-linux"
    "armv7l-linux"
    "i686-linux"
    "x86_64-linux"
  ];

  makeIntegrationTest =
    packageName:
    runTest {
      imports = [ ./basic.nix ];
      name = "ocis-${packageName}";
      _module.args.package = pkgs.${packageName};
    };

  evaluate =
    {
      stateVersion,
      package ? null,
    }:
    (evalSystem {
      system = {
        inherit stateVersion;
      };
      services.ocis = {
        enable = true;
        package = lib.mkIf (package != null) package;
      };
    }).config;

  ocisWarnings = config: lib.filter (lib.hasInfix "ownCloud Infinite Scale") config.warnings;

  defaultCases = [
    {
      stateVersion = "25.11";
      expected = "ocis_5-bin";
    }
    {
      stateVersion = "26.05";
      expected = "ocis_5-bin";
    }
    {
      stateVersion = "26.11";
      expected = "ocis_81-bin";
    }
  ];

  warningCases = [
    {
      current = "ocis_5-bin";
      next = "ocis_70-bin";
    }
    {
      current = "ocis_70-bin";
      next = "ocis_71-bin";
    }
    {
      current = "ocis_71-bin";
      next = "ocis_72-bin";
    }
    {
      current = "ocis_72-bin";
      next = "ocis_73-bin";
    }
    {
      current = "ocis_73-bin";
      next = "ocis_80-bin";
    }
    {
      current = "ocis_80-bin";
      next = "ocis_81-bin";
    }
  ];

  defaultAssertions = map (
    case:
    let
      actual = (evaluate { inherit (case) stateVersion; }).services.ocis.package.pname;
    in
    lib.assertMsg (actual == case.expected)
      "services.ocis.package defaults to ${actual} for stateVersion ${case.stateVersion}, expected ${case.expected}"

  ) defaultCases;

  warningAssertions = map (
    case:
    let
      warnings = ocisWarnings (evaluate {
        stateVersion = "26.11";
        package = pkgs.${case.current};
      });
      warning = builtins.head warnings;
      unrelatedPackages = lib.remove case.current (lib.remove case.next packageNames);
    in
    lib.assertMsg (
      builtins.length warnings == 1
      && lib.hasInfix case.current warning
      && lib.hasInfix case.next warning
      && lib.all (packageName: !lib.hasInfix packageName warning) unrelatedPackages
    ) "services.ocis must warn only that ${case.current} upgrades next to ${case.next}"
  ) warningCases;

  latestWarnings = ocisWarnings (evaluate {
    stateVersion = "25.11";
    package = pkgs.ocis_81-bin;
  });

  customPackage =
    pkgs.runCommand "custom-ocis"
      {
        version = "unstable-2026-07-23";
        meta.mainProgram = "ocis";
      }
      ''
        mkdir -p $out/bin
        touch $out/bin/ocis
        chmod +x $out/bin/ocis
      '';

  customWarnings = ocisWarnings (evaluate {
    stateVersion = "26.11";
    package = customPackage;
  });

  platformAssertions = map (
    packageName:
    let
      actual = lib.sort builtins.lessThan pkgs.${packageName}.meta.platforms;
    in
    lib.assertMsg (actual == supportedSystems)
      "${packageName} advertises ${builtins.toJSON actual}, expected ${builtins.toJSON supportedSystems}"
  ) newPackageNames;

  canonicalUpdateScript = builtins.elemAt pkgs.ocis_70-bin.updateScript 0;

  updateScriptAssertions = map (
    packageName:
    let
      updateScript = pkgs.${packageName}.updateScript;
    in
    lib.assertMsg (
      builtins.isList updateScript
      && builtins.length updateScript == 2
      && builtins.elemAt updateScript 0 == canonicalUpdateScript
      && builtins.elemAt updateScript 1 == packageName
    ) "${packageName} must invoke the shared updater with its package name"
  ) newPackageNames;

  moduleAssertions =
    defaultAssertions
    ++ warningAssertions
    ++ platformAssertions
    ++ updateScriptAssertions
    ++ [
      (lib.assertMsg (latestWarnings == [ ]) "ocis_81-bin must not emit an upgrade warning")
      (lib.assertMsg (
        customWarnings == [ ]
      ) "an unknown custom oCIS package must not emit an upgrade warning")
    ];
in
lib.genAttrs packageNames makeIntegrationTest
// {
  environment-only = runTest ./environment-only.nix;

  module =
    assert lib.all lib.id moduleAssertions;
    pkgs.runCommand "nixos-ocis-module-test" { } ''
      touch $out
    '';
}
