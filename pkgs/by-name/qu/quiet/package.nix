{ lib
, stdenv
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "quiet";
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/TryQuiet/quiet/releases/download/quiet@${version}/Quiet-${version}.AppImage";
    hash = "sha256-2rrm8ejuDR1yjj5qpmKLYMniuirTQEtMTd0pUGkgEhU=";
  };

  extraInstallCommands = ''
    mv $out/bin/quiet-${version} $out/bin/${pname}
  '';

  meta = {
    description = "A private, p2p alternative to Slack and Discord built on Tor & IPFS";
    homepage = "https://github.com/TryQuiet/quiet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
  };
}
