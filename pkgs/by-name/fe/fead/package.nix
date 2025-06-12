{
  lib,
  stdenv,
  fetchzip,
  python3,
  help2man,
}:

stdenv.mkDerivation rec {
  pname = "fead";
  version = "1.0.0";

  src = fetchzip {
    url = "https://trong.loang.net/~cnx/fead/snapshot/fead-${version}.tar.gz";
    hash = "sha256-cbU379Zz+mwRqEHiDUlGvWheLkkr0YidHeVs/1Leg38=";
  };

  nativeBuildInputs = [ help2man ];
  buildInputs = [ python3 ];

  # Needed for man page generation in build phase
  postPatch = ''
    patchShebangs src/fead.py
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  # Already done in postPatch phase
  dontPatchShebangs = true;

  # The package has no tests.
  doCheck = false;

  meta = {
    description = "Advert generator from web feeds";
    homepage = "https://trong.loang.net/~cnx/fead";
    license = lib.licenses.agpl3Plus;
    changelog = "https://trong.loang.net/~cnx/fead/tag?h=${version}";
    maintainers = with lib.maintainers; [ McSinyx ];
    mainProgram = "fead";
  };
}
