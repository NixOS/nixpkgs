{ lib, stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "star";
  version = "2.7.9a";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "sha256-p1yaIbSGu8K5AkqJj0BAzuoWsXr25eCNoQmLXYQeg4E=";
  };

  sourceRoot = "source/source";

  postPatch = ''
    substituteInPlace Makefile --replace "/bin/rm" "rm"
  '';

  buildInputs = [ zlib ];

  buildFlags = [ "STAR" "STARlong" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -D STAR STARlong -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Spliced Transcripts Alignment to a Reference";
    homepage = "https://github.com/alexdobin/STAR";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.arcadio ];
  };
}
