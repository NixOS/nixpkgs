{ stdenv, fetchFromGitHub, cmake, wrapQtAppsHook, qtbase }:

stdenv.mkDerivation rec {
  pname = "rclone-browser";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kapitainsky";
    repo = "RcloneBrowser";
    rev = version;
    sha256 = "14ckkdypkfyiqpnz0y2b73wh1py554iyc3gnymj4smy0kg70ai33";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtbase ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Graphical Frontend to Rclone written in Qt";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
