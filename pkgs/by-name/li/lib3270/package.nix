{
  lib,
  stdenv,
  curl,
  fetchFromGitHub,
  gettext,
  meson,
  ninja,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lib3270";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "PerryWerneck";
    repo = "lib3270";
    tag = finalAttrs.version;
    hash = "sha256-AGS7RkMeVKe2Ed5Aj3oHdbiGMoYGmq2Wlkcd4wSm4J8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    gettext
    openssl
  ];

  enableParallelBuilding = true;

  meta = {
    description = "TN3270 client Library";
    homepage = "https://github.com/PerryWerneck/lib3270";
    changelog = "https://github.com/PerryWerneck/lib3270/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ vifino ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
