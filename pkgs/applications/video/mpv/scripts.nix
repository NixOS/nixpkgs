{
  lib,
  config,
  newScope,
  runCommand,
}:

let
  unionOfDisjoints = lib.fold lib.attrsets.unionOfDisjoint { };

  addTests =
    attrPath: drv:
    if !lib.isDerivation drv then
      drv
    else
      let
        name = lib.concatStringsSep "." attrPath;

        inherit (drv) scriptName;
        scriptPath = "share/mpv/scripts/${scriptName}";
        fullScriptPath = "${drv}/${scriptPath}";
      in
      drv.overrideAttrs (old: {
        passthru = (old.passthru or { }) // {
          tests = unionOfDisjoints [
            (old.passthru.tests or { })

            {
              scriptName-is-valid =
                runCommand "mpvScripts.${name}.passthru.tests.scriptName-is-valid"
                  {
                    meta.maintainers = with lib.maintainers; [ nicoo ];
                    preferLocalBuild = true;
                  }
                  ''
                    if [ -e "${fullScriptPath}" ]; then
                      touch $out
                    else
                      echo "mpvScripts.${name} does not contain a script named \"${scriptName}\"" >&2
                      exit 1
                    fi
                  '';
            }

            # can't check whether `fullScriptPath` is a directory, in pure-evaluation mode
            (lib.optionalAttrs
              (
                !lib.any (s: lib.hasSuffix s drv.passthru.scriptName) [
                  ".js"
                  ".lua"
                  ".so"
                ]
              )
              {
                single-main-in-script-dir =
                  runCommand "mpvScripts.${name}.passthru.tests.single-main-in-script-dir"
                    {
                      meta.maintainers = with lib.maintainers; [ nicoo ];
                      preferLocalBuild = true;
                    }
                    ''
                      die() {
                        echo "$@" >&2
                        exit 1
                      }

                      cd "${drv}/${scriptPath}"  # so the glob expands to filenames only
                      mains=( main.* )
                      if [ "''${#mains[*]}" -eq 1 ]; then
                        touch $out
                      elif [ "''${#mains[*]}" -eq 0 ]; then
                        die "'${scriptPath}' contains no 'main.*' file"
                      else
                        die "'${scriptPath}' contains multiple 'main.*' files:" "''${mains[*]}"
                      fi
                    '';
              }
            )
          ];
        };
      });

  scope =
    self:
    lib.mapAttrsRecursiveCond (x: x.recurseForDerivations or false) addTests (
      lib.recurseIntoAttrs (
        lib.filesystem.packagesFromDirectoryRecursive {
          inherit (self) callPackage;
          directory = ./scripts;
        }
      )
    );

  aliases = self: {
    acompressor = self.mpv.acompressor; # added 2024-11-28
    autocrop = self.mpv.autocrop; # added 2024-11-28
    autodeint = self.mpv.autodeint; # added 2024-11-28
    autoload = self.mpv.autoload; # added 2024-11-28
    blacklistExtensions = self.occivink.blacklistExtensions; # added 2024-11-28
    crop = self.occivink.crop; # added 2024-11-28
    encode = self.occivink.encode; # added 2024-11-28
    seekTo = self.occivink.seekTo; # added 2024-11-28
    youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
  };
in

lib.pipe scope [
  (lib.makeScope newScope)
  (
    self:
    assert builtins.intersectAttrs self (aliases self) == { };
    self // lib.optionalAttrs config.allowAliases (aliases self)
  )
]
