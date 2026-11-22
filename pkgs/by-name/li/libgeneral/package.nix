{
  lib,
  clangStdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libimobiledevice,
  libusb1,
  avahi,
}:
clangStdenv.mkDerivation (finalAttrs: {
  pname = "libgeneral";
  version = "93";

  src = fetchFromGitHub {
    owner = "tihmstar";
    repo = "libgeneral";
    tag = finalAttrs.version;
    hash = "sha256-Htz3SdYcURolqBm4coa16JMHOb6RgIQaPCkLo6/GM5g=";
  };

  # Do not depend on git to calculate version, instead
  # pass version via configureFlag
  patches = [ ./configure-version.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--with-version-commit-count=${finalAttrs.version}"
  ];

  strictDeps = true;

  meta = {
    description = "Helper library used by usbmuxd2";
    homepage = "https://github.com/tihmstar/libgeneral";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
