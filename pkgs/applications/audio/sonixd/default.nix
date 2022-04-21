{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "sonixd";
  version = "0.15.1";

  src = fetchurl {
    url = "https://github.com/jeffvli/sonixd/releases/download/v${version}/Sonixd-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-23WU1nwvrzyw0J+Pplm3JbsScjJxu+RhmwVoe/PjozY=";
  };

  extraInstallCommands = ''
    mv $out/bin/sonixd-${version} $out/bin/sonixd
  '';

  meta = with lib; {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/sonixd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
  };
}

