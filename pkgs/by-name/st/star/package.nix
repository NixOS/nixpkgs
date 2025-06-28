{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
  zlib,
  llvmPackages
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

  nativeBuildInputs = [ xxd ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ llvmPackages.openmp ];

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
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = [ maintainers.arcadio ];
  };
}
