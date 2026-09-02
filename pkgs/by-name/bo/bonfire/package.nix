{
  _experimental-update-script-combinators,
  callPackage,
  gitMinimal,
  gitUpdater,
  lib,
  nixosTests,
  writeShellApplication,
  writeText,
}:
let
  extensions = import ./extensions.nix {
    inherit
      _experimental-update-script-combinators
      callPackage
      lib
      ;
  };
  bonfire-app = extensions.ember;
in
(writeText "bonfire-${bonfire-app.version}" ''
  This package only exists to provide a location for an `updateScript`
  updating `src` just once before calling each extensions' `update.script`.

  To build Bonfire, use one of: ${
    lib.concatMapStrings (ext: "\n- bonfire-${ext}") (lib.attrNames extensions)
  }
'').overrideAttrs
  (
    finalAttrs: previousAttrs: {
      # Let `update-source-version` find where to update `version` and `hash`.
      pos = builtins.unsafeGetAttrPos "src" bonfire-app;
      __structuredAttrs = true;
      strictDeps = true;
      passthru = extensions // {
        inherit (bonfire-app) src;
        # Usage: `nix -L develop -f maintainers/scripts/update.nix --argstr package bonfire`
        updateScript = _experimental-update-script-combinators.sequence [
          (gitUpdater { rev-prefix = "v"; })
          {
            supportedFeatures = [ "silent" ];
            command = lib.getExe (writeShellApplication {
              name = "bonfire-update-extensions";
              runtimeInputs = [
                gitMinimal
              ];
              text = lib.concatLines [
                # Explanation: avoid a costly update if `gitUpdater` has not modified this file.
                ''
                  set -x
                  if git diff --exit-code -- pkgs/by-name/bo/bonfire/generic.nix; then
                    exit 0
                  fi
                ''
                # Explanation: clean everything to avoid leftovers.
                ''
                  rm -rf pkgs/by-name/bo/bonfire-{${lib.concatStringsSep "," (lib.attrNames extensions)}}/deps{.nix,/}
                  mkdir -p pkgs/by-name/bo/bonfire-{${lib.concatStringsSep "," (lib.attrNames extensions)}}/deps/
                ''
                # Explanation: updating all extensions using the same `src` set by `gitUpdater`
                # to avoid any extension ending up using a `src` no longer matching
                # the files generated in `pkgs/by-name/bo/bonfire-${extension}/deps{.nix,/}`,
                # which can happen, and did happened when upstream releases a new version
                # during the (long) update of a extension,
                # which is likely since each extension update can easily last one hour.
                (lib.concatMapStringsSep "\n" (
                  extension:
                  lib.optionalString (!(extensions.${extension}.meta.broken or false)) ''
                    ${lib.getExe (extensions.${extension}.update.script)}
                  ''
                ) (lib.attrNames extensions))
              ];
            });
          }
        ];
        tests = {
          nixos-run = nixosTests.bonfire;
        };
      };
    }
  )
