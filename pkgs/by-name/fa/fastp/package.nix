{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  libdeflate,
  libhwy,
  isa-l,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastp";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "OpenGene";
    repo = "fastp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4qx4enFm9UY2NB68QJOBVx9AGAZuoPqCpnxFDHfKL1E=";
  };

  buildInputs = [
    zlib
    libdeflate
    libhwy
    isa-l
  ];

  installPhase = ''
    install -D fastp $out/bin/fastp
  '';

  strictDeps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Ultra-fast all-in-one FASTQ preprocessor";
    mainProgram = "fastp";
    license = lib.licenses.mit;
    homepage = "https://github.com/OpenGene/fastp";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.x86_64;
  };
})
