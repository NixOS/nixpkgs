{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fuse3,
  readline,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "android-file-transfer";
  version = "4.5";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    tag = "v${version}";
    sha256 = "sha256-G+ErwZ/F8Cl8WLSzC+5LrEWWqNZL3xDMBvx/gjkgAXk=";
  };

  patches = [ ./darwin-dont-vendor-dependencies.patch ];

  nativeBuildInputs = [
    cmake
    readline
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    fuse3
    qt6.qtbase
    qt6.qttools
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/*.app $out/Applications
  '';

  meta = with lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = "https://whoozle.github.io/android-file-transfer-linux/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.unix;
  };
}
