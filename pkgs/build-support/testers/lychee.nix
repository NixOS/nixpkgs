deps@{
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
  # or doc/builders/testers.chapter.md
  lycheeLinkCheck =
    {
      site,
      remap ? { },
      lychee ? deps.lychee,
      extraConfig ? { },
    }:
    stdenv.mkDerivation (finalAttrs: {
      name = "lychee-link-check";
      inherit site;
      nativeBuildInputs = [ finalAttrs.passthru.lychee ];
      configFile = (formats.toml { }).generate "lychee.toml" finalAttrs.passthru.config;

      # These can be overriden with overrideAttrs if needed.
      passthru = {
        inherit lychee remap;
        config =
          {
            include_fragments = true;
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
