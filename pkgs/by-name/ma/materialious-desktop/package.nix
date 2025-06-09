{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  nix-update-script,
}:

let
  pname = "materialious-desktop";
  version = "1.6.23";

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Materialious/Materialious/${version}/branding/Materialious.png";
    sha256 = "sha256-VmuBAfhpNO3UdhdEQ7cZV/FI8jJgg4mNyLvIY3slIoY=";
  };

  desktopItem = makeDesktopItem {
    inherit icon;
    name = pname;
    exec = pname;
    desktopName = "Materialious";
    genericName = "Invidious Frontend";
  };

  dist =
    {
      aarch64-linux = {
        arch = "arm64";
        sha256 = "sha256-1qwJWrRJLdKAKTSDq7m0OWgQ3I1/aBJJwi1rW3TxhQM=";
      };

      x86_64-linux = {
        arch = "x86_64";
        sha256 = "sha256-2a75l7/aVkyi0NXkyGYZiRTKGvzQ9evk7hC+JTBgPZk=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
appimageTools.wrapType2 {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/Materialious/Materialious/releases/download/${version}/Materialious-${version}-linux-${dist.arch}.AppImage";
    hash = dist.sha256;
  };

  extraInstallCommands = ''
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern material design desktop app for Invidious";
    homepage = "https://materialio.us";
    license = [ lib.licenses.agpl3Plus ];
    maintainers = with lib.maintainers; [ romner-set ];
    mainProgram = "materialious-desktop";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
