# Arguments that this derivation gets when it is created with `callPackage`
{ stdenv
, buildEnv
, lib
, makeWrapper
, mpvScripts
, symlinkJoin
, writeTextDir
, yt-dlp
}:

# the unwrapped mpv derivation - 1st argument to `wrapMpv`
mpv:

let
  # arguments to the function (exposed as `wrapMpv` in all-packages.nix)
  wrapper = {
    extraMakeWrapperArgs ? [],
    youtubeSupport ? true,
    # a set of derivations (probably from `mpvScripts`) where each is
    # expected to have a `scriptName` passthru attribute that points to the
    # name of the script that would reside in the script's derivation's
    # `$out/share/mpv/scripts/`.
    # A script can optionally also provide an `extraWrapperArgs` passthru attribute.
    scripts ? [],
    extraUmpvWrapperArgs ? []
  }:
  let
    binPath = lib.makeBinPath ([
      mpv.luaEnv
    ] ++ lib.optionals youtubeSupport [
      yt-dlp
    ] ++ lib.optionals mpv.vapoursynthSupport [
      mpv.vapoursynth.python3
    ]);
    # All arguments besides the input and output binaries (${mpv}/bin/mpv and
    # $out/bin/mpv). These are used by the darwin specific makeWrapper call
    # used to wrap $out/Applications/mpv.app/Contents/MacOS/mpv as well.
    mostMakeWrapperArgs = lib.strings.escapeShellArgs ([ "--inherit-argv0"
      # These are always needed (TODO: Explain why)
      "--prefix" "LUA_CPATH" ";" "${mpv.luaEnv}/lib/lua/${mpv.lua.luaversion}/?.so"
      "--prefix" "LUA_PATH" ";" "${mpv.luaEnv}/share/lua/${mpv.lua.luaversion}/?.lua"
    ] ++ lib.optionals mpv.vapoursynthSupport [
      "--prefix" "PYTHONPATH" ":" "${mpv.vapoursynth}/${mpv.vapoursynth.python3.sitePackages}"
    ] ++ lib.optionals (binPath != "") [
      "--prefix" "PATH" ":" binPath
    ] ++ (lib.lists.flatten (map
      # For every script in the `scripts` argument, add the necessary flags to the wrapper
      (script:
        [
          "--add-flags"
          # Here we rely on the existence of the `scriptName` passthru
          # attribute of the script derivation from the `scripts`
          "--script=${script}/share/mpv/scripts/${script.scriptName}"
        ]
        # scripts can also set the `extraWrapperArgs` passthru
        ++ (script.extraWrapperArgs or [])
      ) scripts
    )) ++ extraMakeWrapperArgs)
    ;
    umpvWrapperArgs = lib.strings.escapeShellArgs ([
      "--inherit-argv0"
      "--set" "MPV" "${placeholder "out"}/bin/mpv"
    ] ++ extraUmpvWrapperArgs)
    ;
  in
    symlinkJoin {
      name = "mpv-with-scripts-${mpv.version}";

      # TODO: don't link all mpv outputs and convert package to mpv-unwrapped?
      paths = [ mpv.all ];

      nativeBuildInputs = [ makeWrapper ];

      passthru.unwrapped = mpv;

      passthru.tests.mpv-scripts-should-not-collide = buildEnv {
        name = "mpv-scripts-env";
        paths = lib.pipe mpvScripts [
          # filters "override" "overrideDerivation" "recurseForDerivations"
          (lib.filterAttrs (key: script: lib.isDerivation script))
          # replaces unfree and meta.broken scripts with decent placeholders
          (lib.mapAttrsToList (key: script:
            if (builtins.tryEval script.outPath).success
            then script
            else writeTextDir "share/mpv/scripts/${script.scriptName}" "placeholder of ${script.name}"
          ))
        ];
      };

      postBuild = ''
        # wrapProgram can't operate on symlinks
        rm "$out/bin/mpv"
        makeWrapper "${mpv}/bin/mpv" "$out/bin/mpv" ${mostMakeWrapperArgs}
        rm "$out/bin/umpv"
        makeWrapper "${mpv}/bin/umpv" "$out/bin/umpv" ${umpvWrapperArgs}
      '' + lib.optionalString stdenv.isDarwin ''
        # wrapProgram can't operate on symlinks
        rm "$out/Applications/mpv.app/Contents/MacOS/mpv"
        makeWrapper "${mpv}/Applications/mpv.app/Contents/MacOS/mpv-bundle" "$out/Applications/mpv.app/Contents/MacOS/mpv" ${mostMakeWrapperArgs}
      '';

      meta = {
        inherit (mpv.meta) homepage description longDescription maintainers;
        mainProgram = "mpv";
      };
    };
in
  lib.makeOverridable wrapper
