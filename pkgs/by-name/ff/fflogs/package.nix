let
  version = "8.3.4";
in { lib, appimageTools, fetchurl }:
appimageTools.wrapType2 {
  name = "fflogs";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    sha256 = "uYV2uB0rjlzBJCtAknOPXHugA5JZVxToHICtZuNY/lE=";
  };

  meta = with lib; {
    homepage = "https://github.com/RPGLogs/Uploaders-fflogs";
    description = "Log uploader for fflogs.com";
    license = with licenses; free;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ bkaylor ];
  };
}
