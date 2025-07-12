{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  blas,
  lapack,
}:

stdenv.mkDerivation rec {
  pname = "plink-ng2";
  version = "2.0.0-a.6.12";

  src = fetchFromGitHub {
    owner = "chrchang";
    repo = "plink-ng";
    tag = "v${version}";
    hash = "sha256-HtWaZQL+z/28lH+VclRbwiDWJpyDQ47VO6mOqNaFQwI=";
  };

  buildInputs =
    [ zlib ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      blas
      lapack
    ];

  preBuild =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeFlagsArray+=(
        CXXFLAGS="-framework Accelerate -Wno-unused-command-line-argument"
        ZLIB=-lz
      )
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      makeFlagsArray+=(
        BLASFLAGS="-lblas -lcblas -llapack"
        ZLIB=-lz
      )
    '';

  sourceRoot = "${src.name}/2.0/build_dynamic";
  makefile = "Makefile";

  installPhase = ''
    runHook preInstall

    install -Dm755 plink2 $out/bin/plink2

    runHook postInstall
  '';

  meta = {
    description = "Whole genome association analysis toolset";
    homepage = "https://www.cog-genomics.org/plink2";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "plink2";
    maintainers = with lib.maintainers; [ acpuchades ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
