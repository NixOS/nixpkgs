{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "mpv-gallery-view";
  version = "0-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "occivink";
    repo = "mpv-gallery-view";
    rev = "4a8e664d52679fff3f05f29aa7a54b86150704bc";
    hash = "sha256-u4PQtTKdE357G1X+Ag0Dexd/jhmZVsAXxdUgEp8bMPw=";
  };

  postPatch = ''
    substituteInPlace \
      scripts/contact-sheet.lua \
      scripts/playlist-view.lua \
      --replace "~~/script-modules/?.lua;" "$out/share/mpv/script-modules/?.lua;"
  '';

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/mpv/scripts scripts/*.lua
    install -Dm444 -t $out/share/mpv/script-modules script-modules/*.lua

    runHook postInstall
  '';

  passthru.scriptName = "{playlist-view,contact-sheet,gallery-thumbgen}.lua";

  meta = with lib; {
    description = "Gallery-view scripts for mpv";
    homepage = "https://github.com/occivink/mpv-gallery-view";
    platforms = platforms.all;
    license = licenses.unlicense;
    maintainers = with maintainers; [ musjj ];
  };
}
