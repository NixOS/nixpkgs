deps@{
  cacert,
  formats,
  lib,
  lychee,
  stdenv,
  writeShellApplication,
}:
let
  inherit (lib) mapAttrsToList throwIf;
  inherit (lib.strings) hasInfix hasPrefix escapeNixString;

  toURL =
    v:
    let
      s = "${v}";
    in
    if hasPrefix builtins.storeDir s then # lychee requires that paths on the file system are prefixed with file://
      "file://${s}"
    else
      s;

  withCheckedName =
    name:
    throwIf (hasInfix " " name) ''
      lycheeLinkCheck: remap patterns must not contain spaces.
      A space marks the end of the regex in lychee.toml.

      Please change attribute name 'remap.${escapeNixString name}'
    '';

  # See https://nixos.org/manual/nixpkgs/unstable/#tester-lycheeLinkCheck
  # or doc/build-helpers/testers.chapter.md
  lycheeLinkCheck =
    {
      site,
      remap ? { },
      lychee ? deps.lychee,
      extraConfig ? { },
      extraArgs ? [ ],
    }:
    stdenv.mkDerivation (finalAttrs: {
      name = "lychee-link-check";
      __structuredAttrs = true;
      inherit site;
      nativeBuildInputs = [
        finalAttrs.passthru.lychee
        cacert
      ];
      configFile = (formats.toml { }).generate "lychee.toml" finalAttrs.passthru.config;
      inherit extraArgs;

      # These can be overridden with overrideAttrs if needed.
      passthru = {
        inherit lychee remap;
        config = {
          include_fragments = "full";
        }
        // lib.optionalAttrs (finalAttrs.passthru.remap != { }) {
          remap = mapAttrsToList (
            name: value: withCheckedName name "${name} ${toURL value}"
          ) finalAttrs.passthru.remap;
        }
        // extraConfig;
        online = writeShellApplication {
          name = "run-lychee-online";
          runtimeInputs = [ finalAttrs.passthru.lychee ];
          # Comment out to run shellcheck:
          checkPhase = "";
          text = ''
            site=${finalAttrs.site}
            configFile=${finalAttrs.configFile}
            echo Checking links on $site
            exec lychee --config $configFile ${lib.escapeShellArgs extraArgs} $site "$@"
          '';
        };
      };
      buildCommand = ''
        echo Checking internal links on $site
        lychee --offline --config $configFile "''${extraArgs[@]}" $site
        touch $out
      '';
    });

in
{
  inherit lycheeLinkCheck;
}
