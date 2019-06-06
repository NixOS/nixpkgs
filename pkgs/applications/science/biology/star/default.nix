{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "star";
  version = "2.7.1a";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "0n6g4s4hgw7qygs1z97j7a2dgz8gfaa4cv5pjvvvmarvk0x07hyg";
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

  meta = with stdenv.lib; {
    description = "Spliced Transcripts Alignment to a Reference";
    homepage = "https://github.com/alexdobin/STAR";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.arcadio ];
  };
}
