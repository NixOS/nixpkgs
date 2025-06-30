{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
  zlib,
  llvmPackages,
  star,
  testers,
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

  makeFlags = [
    "CXXFLAGS_SIMD="
  ];

  preBuild = ''
    export CXXFLAGS="-std=c++14${lib.optionalString stdenv.isDarwin " -DSHM_NORESERVE=0"}"
  '';

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

  passthru.tests.version = testers.testVersion {
    package = star;
    command = "STAR --version || true";
    version = "${version}";
  };

  meta = with lib; {
    description = "Spliced Transcripts Alignment to a Reference";
    homepage = "https://github.com/alexdobin/STAR";
    license = licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = [ maintainers.arcadio ];
  };
}
