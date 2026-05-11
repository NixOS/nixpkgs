{
  symlinkJoin,
  wrapGAppsHook4,
  gtk4,
  feedbackd,
  librsvg,
  glycin-loaders,
  highscore-unwrapped,
  highscore-blastem,
  highscore-bsnes,
  highscore-desmume,
  highscore-gearsystem,
  highscore-mednafen,
  highscore-mgba,
  highscore-mupen64plus,
  highscore-nestopia,
  highscore-prosystem,
  highscore-sameboy,
  highscore-stella,

  # Allow users to override
  cores ? builtins.filter (p: p.meta.available) [
    highscore-blastem
    highscore-bsnes
    highscore-desmume
    highscore-gearsystem
    highscore-mednafen
    highscore-mgba
    highscore-mupen64plus
    highscore-nestopia
    highscore-prosystem
    highscore-sameboy
    highscore-stella
  ],
}:

symlinkJoin {
  pname = "highscore";
  inherit (highscore-unwrapped) version meta;

  paths = [ highscore-unwrapped ] ++ cores;

  nativeBuildInputs = [
    wrapGAppsHook4
  ];

  buildInputs = [
    # For gsettings-schemas
    highscore-unwrapped
    gtk4
    feedbackd
    # For GDK_PIXBUF_MODULE_FILE
    librsvg
  ];

  dontWrapGApps = true;

  # symlinkJoin doesn't run other build phases
  postBuild = ''
    rm $out/share/dbus-1/services/app.drey.Highscore{,.SearchProvider}.service
    cp {${highscore-unwrapped},$out}/share/dbus-1/services/app.drey.Highscore.service
    cp {${highscore-unwrapped},$out}/share/dbus-1/services/app.drey.Highscore.SearchProvider.service
    substituteInPlace $out/share/dbus-1/services/app.drey.Highscore{,.SearchProvider}.service \
      --replace-fail "${highscore-unwrapped}" "$out"

    gappsWrapperArgsHook

    makeWrapper ${highscore-unwrapped}/bin/highscore $out/bin/highscore \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share" \
      --set HIGHSCORE_CORES_DIR $out/lib/highscore/cores
  '';
}
