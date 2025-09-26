{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libplist
, libimobiledevice-glue
, curl
}:

stdenv.mkDerivation rec {
  pname = "libtatsu";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libtatsu";
    rev = "ec295dd6585a900207125d41fab8535ce0c8d3dc";
    hash = "sha256-vf4xBTTGDJCTj4TMLOhojjAfzSbkx+ogGBnf+UeumG0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
    curl
  ];

  preAutoreconf = ''
    echo ${version} > .tarball-version
    export PACKAGE_VERSION=${version}
  '';

  meta = with lib; {
    description = "Library handling the communication with Apple's Tatsu Signing Server (TSS)";
    homepage = "https://github.com/libimobiledevice/libtatsu";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nxm ];
  };
}

