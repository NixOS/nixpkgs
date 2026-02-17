{
  stdenv,
  buildEnv,
  lib,
  makeBinaryWrapper,
  mpvScripts,
  mpv-unwrapped,
  symlinkJoin,
  writeTextDir,
  yt-dlp,
  extraMakeWrapperArgs ? [ ],
  youtubeSupport ? true,
  # a set of derivations (probably from `mpvScripts`) where each is expected
  # to have a `scriptName` passthru attribute that points to the name of the
  # script that would reside in the script's derivation's
  # `$out/share/mpv/scripts/`.
  #
  # A script can optionally also provide `passthru.extraWrapperArgs`
  # attribute.
  scripts ? [ ],
  extraUmpvWrapperArgs ? [ ],
}:

let
  binPath = lib.makeBinPath (
    [
      mpv-unwrapped.luaEnv
    ]
    ++ lib.optionals mpv-unwrapped.vapoursynthSupport [
      mpv-unwrapped.vapoursynth.python3
    ]
  );

  # With some tools, we want to prioritize tools that are in PATH. For example, users may want
  # to quickly expose a newer version of yt-dlp through the nix shell because it needs to be
  # kept up-to-date for it to work.
  fallbackBinPath = lib.makeBinPath (lib.optionals youtubeSupport [ yt-dlp ]);

  # All arguments besides the input and output binaries (${mpv-unwrapped}/bin/mpv and
  # $out/bin/mpv). These are used by the darwin specific makeWrapper call
  # used to wrap $out/Applications/mpv.app/Contents/MacOS/mpv as well.
  mostMakeWrapperArgs = lib.strings.escapeShellArgs (
    [
      "--inherit-argv0"
      # These are always needed (TODO: Explain why)
      "--prefix"
      "LUA_CPATH"
      ";"
      "${mpv-unwrapped.luaEnv}/lib/lua/${mpv-unwrapped.lua.luaversion}/?.so"
      "--prefix"
      "LUA_PATH"
      ";"
      "${mpv-unwrapped.luaEnv}/share/lua/${mpv-unwrapped.lua.luaversion}/?.lua"
    ]
    ++ lib.optionals mpv-unwrapped.vapoursynthSupport [
      "--prefix"
      "PYTHONPATH"
      ":"
      "${mpv-unwrapped.vapoursynth}/${mpv-unwrapped.vapoursynth.python3.sitePackages}"
    ]
    ++ lib.optionals (binPath != "") [
      "--prefix"
      "PATH"
      ":"
      binPath
    ]
    ++ lib.optionals (fallbackBinPath != "") [
      "--suffix"
      "PATH"
      ":"
      fallbackBinPath
    ]
    ++ (lib.lists.flatten (
      map
        # For every script in the `scripts` argument, add the necessary flags to the wrapper
        (
          script:
          let
            mkScriptArgs = script: scriptName: [
              "--add-flags"
              "--script=${script}/share/mpv/scripts/${scriptName}"
            ];
          in
          # Here we rely on the existence of the `scriptName` passthru
          # attribute of the script derivation from the `scripts`
          (mkScriptArgs script script.scriptName)
          # scripts might need others to be explicitly loaded
          ++ (map (extraScriptName: mkScriptArgs script extraScriptName) (script.extraScriptsToLoad or [ ]))
          # scripts can also set the `extraWrapperArgs` passthru
          ++ (script.extraWrapperArgs or [ ])
        )
        scripts
    ))
    ++ extraMakeWrapperArgs
  );
  umpvWrapperArgs = lib.strings.escapeShellArgs (
    [
      "--inherit-argv0"
      "--set"
      "MPV"
      "${placeholder "out"}/bin/mpv"
    ]
    ++ extraUmpvWrapperArgs
  );
in
symlinkJoin {
  name = "mpv-with-scripts-${mpv-unwrapped.version}";

  # TODO: don't link all mpv outputs
  paths = [ mpv-unwrapped.all ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  passthru.unwrapped = mpv-unwrapped;

  passthru.tests.mpv-scripts-should-not-collide = buildEnv {
    name = "mpv-scripts-env";
    paths = lib.pipe mpvScripts [
      # filters "override" "overrideDerivation" "recurseForDerivations"
      (lib.filterAttrs (key: script: lib.isDerivation script))
      # replaces unfree and meta.broken scripts with decent placeholders
      (lib.mapAttrsToList (
        key: script:
        if (builtins.tryEval script.outPath).success then
          script
        else
          writeTextDir "share/mpv/scripts/${script.scriptName}" "placeholder of ${script.name}"
      ))
    ];
  };

  postBuild = ''
    # wrapProgram can't operate on symlinks
    rm "$out/bin/mpv"
    makeWrapper "${mpv-unwrapped}/bin/mpv" "$out/bin/mpv" ${mostMakeWrapperArgs}
    rm "$out/bin/umpv"
    makeWrapper "${mpv-unwrapped}/bin/umpv" "$out/bin/umpv" ${umpvWrapperArgs}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # wrapProgram can't operate on symlinks
    rm "$out/Applications/mpv.app/Contents/MacOS/mpv"
    makeWrapper "${mpv-unwrapped}/Applications/mpv.app/Contents/MacOS/mpv" "$out/Applications/mpv.app/Contents/MacOS/mpv" ${mostMakeWrapperArgs}
  '';

  meta = {
    inherit (mpv-unwrapped.meta)
      homepage
      description
      longDescription
      maintainers
      ;
    mainProgram = "mpv";
  };
}
