{ symlinkJoin
, lib
, spotify-unwrapped
, makeWrapper

  # High-DPI support: Spotify's --force-device-scale-factor argument; not added
  # if `null`, otherwise, should be a number.
, deviceScaleFactor ? null
}:

symlinkJoin {
  name = "spotify-${spotify-unwrapped.version}";

  paths = [ spotify-unwrapped.out ];

  nativeBuildInputs = [ makeWrapper ];
  preferLocalBuild = true;
  passthru.unwrapped = spotify-unwrapped;
  postBuild = ''
    wrapProgram $out/bin/spotify \
        ${lib.optionalString (deviceScaleFactor != null) ''
            --add-flags ${lib.escapeShellArg "--force-device-scale-factor=${
                builtins.toString deviceScaleFactor
              }"}
        ''}
  '';

  meta = spotify-unwrapped.meta // {
    priority = (spotify-unwrapped.meta.priority or 0) - 1;
  };
}
