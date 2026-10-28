{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  libimobiledevice-glue,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtatsu";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libtatsu";
    tag = finalAttrs.version;
    hash = "sha256-vf4xBTTGDJCTj4TMLOhojjAfzSbkx+ogGBnf+UeumG0=";
  };

  preAutoreconf = ''
    echo ${finalAttrs.version} > .tarball-version
    export PACKAGE_VERSION=${finalAttrs.version}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
    curl
  ];

  meta = {
    description = "Library handling the communication with Apple's Tatsu Signing Server (TSS)";
    homepage = "https://github.com/libimobiledevice/libtatsu";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nxm ];
  };
})
