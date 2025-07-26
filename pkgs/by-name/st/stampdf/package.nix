{ stdenv, fetchurl, lib, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "stampdf";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/pb-/stampdf/releases/download/0.9.0/stampdf";
    sha256 = "sha256-hHJ5F9ANh8HoicZbUzWc7ZSHkrQ+ywQex0JAuUK33Xk=";
  };

  dontUnpack = true;

  buildInputs = [ jdk ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -m755 -D $src $out/bin/stampdf
    wrapProgram $out/bin/stampdf --prefix PATH : ${lib.makeBinPath [ jdk ]}
  '';

  meta = with lib; {
    description = "Stamp PDFs with a short textual identifier";
    homepage = "https://github.com/pb-/stampdf";
    license = licenses.mit;
    maintainers = with maintainers; [ pb- ];
    mainProgram = "stampdf";
  };
}
