{
  lib,
  stdenv,
  fetchurl,
  m2libc,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mescc-tools";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://savannah/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-toL3v1dvieVdCxxjjZ3i2b6yhVciaPWPq/TtFNm2V1w=";
  };

  # Don't use vendored M2libc
  postPatch = ''
    rm -r M2libc
    ln -s ${m2libc}/include/M2libc M2libc
    patchShebangs --build Kaem/test.sh
  '';

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";
  nativeCheckInputs = [ which ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://savannah.nongnu.org/projects/mescc-tools";
    license = licenses.gpl3Only;
    teams = [ teams.minimal-bootstrap ];
    inherit (m2libc.meta) platforms;
  };
})
