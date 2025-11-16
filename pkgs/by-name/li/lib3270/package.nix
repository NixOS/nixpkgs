{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gettext,
  openssl,
  curl,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "lib3270";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = "lib3270";
    rev = version;
    hash = "sha256-AGS7RkMeVKe2Ed5Aj3oHdbiGMoYGmq2Wlkcd4wSm4J8=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    gettext
    openssl
    curl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "TN3270 client Library";
    homepage = "https://github.com/PerryWerneck/lib3270";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.vifino ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
