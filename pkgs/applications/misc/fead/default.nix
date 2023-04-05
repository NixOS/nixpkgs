{ lib, stdenv, fetchFromSourcehut, python3, help2man }:

stdenv.mkDerivation rec {
  pname = "fead";
  version = "0.1.3";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "sha256-cW0GxyvC9url2QAAWD0M2pR4gBiPA3eeAaw77TwMV/0=";
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

  meta = with lib; {
    description = "Advert generator from web feeds";
    homepage = "https://git.sr.ht/~cnx/fead";
    license = licenses.agpl3Plus;
    changelog = "https://git.sr.ht/~cnx/fead/refs/${version}";
    maintainers = with maintainers; [ McSinyx ];
  };
}
