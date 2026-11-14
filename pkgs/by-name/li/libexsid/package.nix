{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  docSupport ? true,
  doxygen,
  libftdi1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libexsid";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "exsid-driver";
    rev = finalAttrs.version;
    hash = "sha256-+cRXGz/vzzqft065aYpgO1g9/mVDVisOQ6q6RErMceE=";
  };

  patches = [
    # fix build with GCC 15 by removing unneeded argument
    (fetchpatch {
      url = "https://github.com/libsidplayfp/exsid-driver/commit/99bfaf25f73f96d588a38a4309fa5f18c364f4d4.patch";
      hash = "sha256-wg/oJieejyXiP5Ff9FRfACNELUt5021kXS1/zT7dMgA=";
    })
  ];

  outputs = [ "out" ] ++ lib.optional docSupport "doc";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optional docSupport doxygen;

  buildInputs = [ libftdi1 ];

  enableParallelBuilding = true;

  installTargets = [ "install" ] ++ lib.optional docSupport "doc";

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/libexsid/doc
    cp -r docs/html $doc/share/libexsid/doc/
  '';

  meta = {
    description = "Driver for exSID USB";
    homepage = "http://hacks.slashdirt.org/hw/exsid/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
