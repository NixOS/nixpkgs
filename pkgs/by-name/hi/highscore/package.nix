{
  symlinkJoin,
  wrapGAppsHook4,
  gtk4,
  feedbackd,
  librsvg,
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
    rm $out/share/dbus-1/services/app.drey.Highscore.service
    sed "s|Exec=.*/highscore|Exec=$out/bin/highscore|" \
      ${highscore-unwrapped}/share/dbus-1/services/app.drey.Highscore.service \
      > $out/share/dbus-1/services/app.drey.Highscore.service

    gappsWrapperArgsHook

    makeWrapper ${highscore-unwrapped}/bin/highscore $out/bin/highscore \
      "''${gappsWrapperArgs[@]}" \
      --set HIGHSCORE_CORES_DIR $out/lib/highscore/cores
  '';
}
