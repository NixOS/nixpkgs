{
  lib,
  stdenv,
  fetchurl,
  libusb1,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rkflashtool";
  version = "6.1";

  src = fetchurl {
    url = "mirror://sourceforge/rkflashtool/rkflashtool-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-K8DsWAyqeQsK7mNDiKkRCkKbr0uT/yxPzj2atYP1Ezk=";
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  installPhase = ''
    mkdir -p $out/bin
    cp rkunpack rkcrc rkflashtool rkparameters rkparametersblock rkunsign rkmisc $out/bin
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/rkflashtool/";
    description = "Tools for flashing Rockchip devices";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.bsd2;
  };
})
