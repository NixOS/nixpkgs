{
  lib,
  stdenv,
  fetchFromSavannah,
  m2libc,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mescc-tools";
  version = "1.5.1";

  src = fetchFromSavannah {
    repo = "mescc-tools";
    rev = "Release_${finalAttrs.version}";
    hash = "sha256-jFDrmzsjKEQKOKlsch1ceWtzUhoJAJVyHjXGVhjE9/U=";
  };

  # Don't use vendored M2libc
  postPatch = ''
    rmdir M2libc
    ln -s ${m2libc}/include/M2libc M2libc
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
    maintainers = teams.minimal-bootstrap.members;
    inherit (m2libc.meta) platforms;
  };
})
