deps@{ formats, lib, lychee, stdenv, writeShellApplication }:
let
  inherit (lib) isPath mapAttrsToList;
  inherit (lib.strings) hasPrefix;

  toURL = v:
    if builtins.isString v && hasPrefix builtins.storeDir v
      || isPath v
    then # lychee requires that paths on the file system are prefixed with file://
      "file://${v}"
    else "${v}";

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-lycheeLinkCheck
  # or doc/builders/testers.chapter.md
  lycheeLinkCheck = {
    site,
    remap ? { },
    lychee ? deps.lychee,
    extraConfig ? { },
  }:
    stdenv.mkDerivation (finalAttrs: {
      name = "lychee-link-check";
      inherit site;
      nativeBuildInputs = [ finalAttrs.passthru.lychee ];
      configFile = (formats.toml {}).generate "lychee.toml" finalAttrs.passthru.config;

      # These can be overriden with overrideAttrs if needed.
      passthru = {
        inherit lychee remap;
        config = {
          include_fragments = true;
        } // lib.optionalAttrs (finalAttrs.passthru.remap != { }) {
          remap = mapAttrsToList (name: value: "${name} ${toURL value}") finalAttrs.passthru.remap;
        } // extraConfig;
        online = writeShellApplication {
          name = "run-lychee-online";
          runtimeInputs = [ finalAttrs.passthru.lychee ];
          # Comment out to run shellcheck:
          checkPhase = "";
          text = ''
            site=${finalAttrs.site}
            configFile=${finalAttrs.configFile}
            echo Checking links on $site
            exec lychee --config $configFile $site "$@"
          '';
        };
      };
      buildCommand = ''
        echo Checking internal links on $site
        lychee --offline --config $configFile $site
        touch $out
      '';
    });

in
{
  inherit lycheeLinkCheck;
}
