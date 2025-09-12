{
  lib,
  stdenv,
  fetchurl,
  m2libc,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mescc-tools";
  version = "1.5.2";

  src = fetchurl {
    url = "mirror://savannah/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-k2wYbLNasuLRq03BG/DXJySNabKOv9sakgst1V8wU8k=";
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
