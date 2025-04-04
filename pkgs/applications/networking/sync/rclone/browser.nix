{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  wrapQtAppsHook,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "rclone-browser";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kapitainsky";
    repo = "RcloneBrowser";
    rev = version;
    sha256 = "14ckkdypkfyiqpnz0y2b73wh1py554iyc3gnymj4smy0kg70ai33";
  };

  patches = [
    # patch for Qt 5.15, https://github.com/kapitainsky/RcloneBrowser/pull/126
    (fetchpatch {
      url = "https://github.com/kapitainsky/RcloneBrowser/commit/ce9cf52e9c584a2cc85a5fa814b0fd7fa9cf0152.patch";
      sha256 = "0nm42flmaq7mva9j4dpp18i1xcv8gr08zfyb9apz1zwn79h1w0c8";
    })
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Graphical Frontend to Rclone written in Qt";
    mainProgram = "rclone-browser";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
