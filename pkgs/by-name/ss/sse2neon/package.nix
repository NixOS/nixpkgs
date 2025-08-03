{
  lib,
  fetchFromGitHub,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sse2neon";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "DLTcollab";
    repo = "sse2neon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vb9k+KjiGodVngza0R18LjfPTlsqFbzqXZqefm6KHj0=";
  };

  postPatch = ''
    # remove warning about gcc < 10
    substituteInPlace sse2neon.h --replace-fail "#warning \"GCC versions" "// "
  '';

  nativeBuildInputs = [ pkg-config ];

  dontInstall = true;
  # use postBuild instead of installPhase, because the build
  # in itself doesn't produce any ($out) output
  postBuild = ''
    mkdir -p $out/include
    install -m444 sse2neon.h $out/include/
  '';

  meta = {
    description = "Translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation";
    homepage = "https://github.com/DLTcollab/sse2neon";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gador ];
  };
})
