{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchzip,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  gtk3,
  gobject-introspection,
  python3Packages,
  wrapGAppsHook3,
}:

let
  data = fetchzip {
    url = "https://mirandir.pagesperso-orange.fr/files/additional-levels.tar.xz";
    sha256 = "167hisscsbldrwrs54gq6446shl8h26qdqigmfg0lq3daynqycg2";
  };
in

stdenv.mkDerivation {
  pname = "jumpnbump";
  version = "1.70-dev";

  # By targeting the development version, we can omit the patches Arch uses
  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "LibreGames";
    repo = "jumpnbump";
    rev = "5744738211ca691444f779aafee3537fb3562516";
    sha256 = "0f1k26jicmb95bx19wgcdpwsbbl343i7mqqqc2z9lkb8drlsyqcy";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    python3Packages.wrapPython
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_net
    gtk3
  ];

  postInstall = ''
    make -C menu PREFIX=$out all install
    cp -r ${data}/* $out/share/jumpnbump/
    rm $out/share/applications/jumpnbump-menu.desktop
    sed -i -e 's+Exec=jumpnbump+Exec=jumpnbump-menu+' $out/share/applications/jumpnbump.desktop
  '';

  pythonPath = with python3Packages; [
    pygobject3
    pillow
  ];
  preFixup = ''
    buildPythonPath "$out $pythonPath"
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Cute, true multiplayer platform game with bunnies";
    homepage = "https://libregames.gitlab.io/jumpnbump/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
  };
}
