{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "star";
  version = "2.7.5c";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "1plx9akrzwjk7f2j94l9ss0apg0asqmrf2bp0728d4bvlhnzmjyy";
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
