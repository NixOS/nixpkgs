deps@{
  cacert,
  formats,
  lib,
  lychee,
  stdenv,
  writeShellApplication,
}:
let
  inherit (lib) mapAttrsToList optionalString throwIf;
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
      relocatable ? null,
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
          root_dir =
            if relocatable == false then
              finalAttrs.site
            else
              "/root-relative-links-are-forbidden-use-relative-links";
        }
        // lib.optionalAttrs (finalAttrs.passthru.remap != { }) {
          remap = mapAttrsToList (
            name: value: withCheckedName name "${name} ${toURL value}"
          ) finalAttrs.passthru.remap;
        }
        // extraConfig;
        # NOTE: The online wrapper does not implement the relocatable hint message.
        # It uses the same configFile (with the fake root_dir), so root-relative
        # links still fail, but without the custom explanation.
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
        rc=0
        lychee --offline --config $configFile "''${extraArgs[@]}" $site 2>&1 | tee lychee.log || rc="''${PIPESTATUS[0]}"
        ${optionalString (relocatable != false) ''
          if [ "$rc" -ne 0 ] && grep -qF "[ERROR] file:///root-relative-links-are-forbidden" lychee.log; then
            echo
            ${
              if relocatable == null then
                ''
                  echo "❄️ ⚠️  Your site contains root-relative links (starting with '/')."
                  echo "Please set the relocatable parameter in lycheeLinkCheck:"
                  echo "  - relocatable = true: root-relative links are forbidden because they"
                  echo "    break when the site is served from a subpath or opened via file:// URLs."
                  echo "  - relocatable = false: root-relative links are allowed because the"
                  echo "    site is always served from the root."
                ''
              else
                ''
                  echo "❄️ ⚠️  Root-relative links (starting with '/') are not allowed because this"
                  echo "site is marked as relocatable (relocatable = true)."
                ''
            }
            echo "See https://nixos.org/manual/nixpkgs/unstable/#tester-lycheeLinkCheck-param-relocatable"
          fi
        ''}
        if [ "$rc" -ne 0 ]; then
          exit "$rc"
        fi
        touch $out
      '';
    });

in
{
  inherit lycheeLinkCheck;
}
