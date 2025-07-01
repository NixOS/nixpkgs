{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "star";
  version = "2.7.11b";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "sha256-4EoS9NOKUwfr6TDdjAqr4wGS9cqVX5GYptiOCQpmg9c=";
  };

  sourceRoot = "${src.name}/source";

  postPatch = ''
    substituteInPlace Makefile --replace "/bin/rm" "rm"
  '';

  nativeBuildInputs = [ xxd ];

  buildInputs = [ zlib ];

  buildFlags = [
    "STAR"
    "STARlong"
  ];

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
