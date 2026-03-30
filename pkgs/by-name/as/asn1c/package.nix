{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asn1c";
  version = "0.9.28";

  src = fetchurl {
    url = "https://lionet.info/soft/asn1c-${finalAttrs.version}.tar.gz";
    hash = "sha256-gAdEC2R+8t2ftz2THDOsEXZOavskN9vmOLtOX8gjhrk=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  buildInputs = [ perl ];

  preConfigure = ''
    patchShebangs examples/crfc2asn1.pl
  '';

  postInstall = ''
    cp -r skeletons/standard-modules $out/share/asn1c
  '';

  doCheck = true;

  meta = {
    homepage = "http://lionet.info/asn1c/compiler.html";
    description = "Open Source ASN.1 Compiler";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ numinit ];
  };
})
