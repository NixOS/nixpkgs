{
  lib,
  config,
  newScope,
  runCommand,
}:

let
  unionOfDisjoints = lib.foldr lib.attrsets.unionOfDisjoint { };

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
    with lib;
    pipe
      {
        inherit (self) callPackage;
        directory = ./scripts;
      }
      [
        packagesFromDirectoryRecursive
        recurseIntoAttrs
        (mapAttrsRecursiveCond (x: x.recurseForDerivations or false) addTests)
      ];

  mkAliases = self: {
    inherit (self.builtins)
      acompressor
      autocrop
      autodeint
      autoload
      ; # added 2024-11-28
    inherit (self.eisa01)
      smart-copy-paste-2
      smartskip
      ; # added 2025-03-09
    inherit (self.occivink)
      blacklistExtensions
      crop
      encode
      seekTo
      ; # added 2024-11-28
    youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
  };
in

lib.pipe scope [
  (lib.makeScope newScope)
  (
    self:
    let
      aliases = mkAliases self;
    in
    assert builtins.intersectAttrs self aliases == { };
    self // lib.optionalAttrs config.allowAliases aliases
  )
]
