{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
  zlib,
  llvmPackages,
  star,
  testers,
  nix-update-script,
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
    substituteInPlace Makefile --replace-fail "-std=c++11" "-std=c++14"
  '';

  nativeBuildInputs = [ xxd ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ llvmPackages.openmp ];

  enableParallelBuilding = true;

  makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [ "CXXFLAGS_SIMD=" ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    export CXXFLAGS="$CXXFLAGS -DSHM_NORESERVE=0"
  '';

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Spliced Transcripts Alignment to a Reference";
    longDescription = ''
      STAR (Spliced Transcripts Alignment to a Reference) is a fast RNA-seq
      read mapper, with support for splice-junction and fusion read detection.
    '';
    homepage = "https://github.com/alexdobin/STAR";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.arcadio ];
  };
}
