{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, extra-cmake-modules
, kactivities
, qtbase
}:

mkDerivation rec {
  pname = "KSmoothDock";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "dangvd";
    repo = "ksmoothdock";
    rev = "v${version}";
    sha256 = "182x47cymgnp5xisa0xx93hmd5wrfigy8zccrr23p4r9hp8xbnam";
  };

  patches = [
    # Fixed hard coded installation path to use CMAKE_INSTALL_BINDIR and CMAKE_INSTALL_PREFIX instead
    (fetchpatch {
      url = "https://github.com/dangvd/ksmoothdock/commit/00799bef8a1c1fe61ef9274866267d9fe9194041.patch";
      sha256 = "1nmb7gf1ggzicxz8k4fd67xhwjy404myqzjpgjym66wqxm0arni4";
    })
    # Pull request to fix build on Qt 5.15 https://github.com/dangvd/ksmoothdock/pull/123
    (fetchpatch {
      url = "https://github.com/dangvd/ksmoothdock/commit/259527aacadb0fd9110d4425b9bf41a15bedce72.patch";
      sha256 = "12nj58v9qqrynarn3gpywih3w27mr4n51z1b8mh0rfbnd2kib8dc";
    })
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ kactivities qtbase ];

  cmakeDir = "../src";

  meta = with lib; {
    description = "A cool desktop panel for KDE Plasma 5";
    license = licenses.mit;
    homepage = "https://dangvd.github.io/ksmoothdock/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
