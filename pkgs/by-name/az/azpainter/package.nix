{
  lib,
  stdenv,
  fetchFromGitLab,
  desktop-file-utils,
  desktopToDarwinBundle,
  shared-mime-info,
  ninja,
  pkg-config,
  libiconv,
  libX11,
  libXcursor,
  libXext,
  libXi,
  freetype,
  fontconfig,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "azpainter";
  version = "3.0.9a";

  src = fetchFromGitLab {
    owner = "azelpg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QWXlRbCGDk1DRtePeDM3tnbtkdlhbkn/oNTqHvmtEA4=";
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    shared-mime-info # for update-mime-info
    ninja
    pkg-config
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    libX11
    libXcursor
    libXext
    libXi
    freetype
    fontconfig
    libjpeg
    libpng
    libtiff
    libwebp
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  preBuild = ''
    cd build
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Full color painting software for illustration drawing";
    homepage = "http://azsky2.html.xdomain.jp/soft/azpainter.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "azpainter";
  };
}
