{ lib
, fetchFromGitHub
, buildNpmPackage
, makeWrapper
, electron_25
, python3
, stdenv
, copyDesktopItems
, makeDesktopItem
}:

let
  pname = "youtube-music";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "th-ch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aYEEUv+dybzcH0aNJlZ19XF++8cswFunrU0H+ZaKm4Y=";
  };

  electron = electron_25;

in
buildNpmPackage {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper python3 ]
    ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems ];

  npmDepsHash = "sha256-XGV0mTywYYxpMitojzIILB/Eu/8dfk/aCvUxIkx4SDQ=";
  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  postBuild = lib.optionalString stdenv.isDarwin ''
    cp -R ${electron}/Applications/Electron.app Electron.app
    chmod -R u+w Electron.app
  '' + ''
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${if stdenv.isDarwin then "." else "${electron}/libexec/electron"} \
      -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv pack/mac*/YouTube\ Music.app $out/Applications
    makeWrapper $out/Applications/YouTube\ Music.app/Contents/MacOS/YouTube\ Music $out/bin/youtube-music
  '' + lib.optionalString (!stdenv.isDarwin) ''
    mkdir -p "$out/share/lib/youtube-music"
    cp -r pack/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/youtube-music"

    pushd assets/generated/icons/png
    for file in *.png; do
      install -Dm0644 $file $out/share/icons/hicolor/''${file//.png}/apps/youtube-music.png
    done
    popd
  '' + ''

    runHook postInstall
  '';

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    makeWrapper ${electron}/bin/electron $out/bin/youtube-music \
      --add-flags $out/share/lib/youtube-music/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "youtube-music";
      exec = "youtube-music %u";
      icon = "youtube-music";
      desktopName = "Youtube Music";
      startupWMClass = "Youtube Music";
      categories = ["AudioVideo"];
    })
  ];

  meta = with lib; {
    description = "Electron wrapper around YouTube Music";
    homepage = "https://th-ch.github.io/youtube-music/";
    license = licenses.mit;
    maintainers = [ maintainers.aacebedo ];
    mainProgram = "youtube-music";
    platforms = platforms.all;
  };
}
