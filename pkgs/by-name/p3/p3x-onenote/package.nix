{
  lib,
  stdenv,
  appimageTools,
  desktop-file-utils,
  fetchurl,
}:

let
  pname = "p3x-onenote";
  version = "2024.10.117";

  plat =
    {
      aarch64-linux = "-arm64";
      armv7l-linux = "-armv7l";
      x86_64-linux = "";
    }
    .${stdenv.hostPlatform.system};

  hash =
    {
      aarch64-linux = "sha256-rBoSdbZhOnpX7mr7Uz5XuO5PB4PKcNMPQP9NqCwiIBc=";
      armv7l-linux = "sha256-8XZ3dpYgHCpo5HjDF4R+U5bO6Fidsf0PlEhOoRB1JA0=";
      x86_64-linux = "sha256-+VxNxSn4awChWZfsICSiyhoTkEjSz4Ft/Wrech1dY14=";
    }
    .${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/patrikx3/onenote/releases/download/v${version}/P3X-OneNote-${version}${plat}.AppImage";
    inherit hash;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/p3x-onenote
    cp ${appimageContents}/p3x-onenote.png $out/share/pixmaps/
    cp ${appimageContents}/p3x-onenote.desktop $out
    cp ${appimageContents}/LICENSE.electron.txt $out/share/licenses/p3x-onenote/LICENSE

    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value $out/bin/p3x-onenote \
      --set-key Comment --set-value "P3X OneNote Linux" \
      --delete-original $out/p3x-onenote.desktop
  '';

  meta = with lib; {
    homepage = "https://github.com/patrikx3/onenote";
    description = "Linux Electron Onenote - A Linux compatible version of OneNote";
    license = licenses.mit;
    maintainers = with maintainers; [ tiagolobocastro ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    mainProgram = "p3x-onenote";
  };
}
