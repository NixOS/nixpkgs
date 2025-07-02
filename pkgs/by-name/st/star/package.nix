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

  postPatch = ''
    substituteInPlace Makefile --replace "-std=c++11" "-std=c++14"
  '';

  nativeBuildInputs = [ xxd ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ llvmPackages.openmp ];

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals stdenv.hostPlatform.isAarch64 [
      "CXXFLAGS_SIMD="
    ]
    ++ lib.optionals stdenv.isDarwin [
      "CPPFLAGS=-DSHM_NORESERVE=0"
      "CXXFLAGS_EXTRA=-DSHM_NORESERVE=0"
    ];

  buildFlags = [
    "STAR"
    "STARlong"
  ];

  installPhase = ''
    runHook preInstall
    install -D STAR STARlong -t $out/bin
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = star;
    command = "STAR --version";
  };

  meta = with lib; {
    description = "Spliced Transcripts Alignment to a Reference";
    homepage = "https://github.com/alexdobin/STAR";
    license = licenses.gpl3Plus
    platforms = platforms.unix;
    maintainers = [ maintainers.arcadio ];
  };
}
