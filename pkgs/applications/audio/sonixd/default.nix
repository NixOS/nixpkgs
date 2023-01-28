{ lib
, fetchurl
, appimageTools
}:

appimageTools.wrapType2 rec {
  pname = "sonixd";
  version = "0.15.3";

  src = fetchurl {
    url = "https://github.com/jeffvli/sonixd/releases/download/v${version}/Sonixd-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-+4L3XAuR7T/z5a58SXre6yUiVi7TvSAs8vPgEC7hcIw=";
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

