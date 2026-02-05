{
  lib,
  stdenv,
  fetchFromGitHub,
  xxd,
  zlib,
  llvmPackages,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "star";
  version = "2.7.11b";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = finalAttrs.version;
    sha256 = "sha256-4EoS9NOKUwfr6TDdjAqr4wGS9cqVX5GYptiOCQpmg9c=";
  };

  sourceRoot = "${finalAttrs.src.name}/source";

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/STAR";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spliced Transcripts Alignment to a Reference";
    longDescription = ''
      STAR (Spliced Transcripts Alignment to a Reference) is a fast RNA-seq
      read mapper, with support for splice-junction and fusion read detection.
    '';
    mainProgram = "STAR";
    homepage = "https://github.com/alexdobin/STAR";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.arcadio ];
  };
})
