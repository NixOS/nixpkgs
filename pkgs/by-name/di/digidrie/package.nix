{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libGL,
  libx11,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "digidrie";
  version = "0.3.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "DigiDrie";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-bmytfZ6/V9eoEnj5xLq3Yzlhy0VGEK6utsfS9OCYWd0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libGL
    libx11
    libjack2
  ];

  sourceRoot = "${finalAttrs.src.name}/plugin/dpf";

  postPatch = ''
    patchShebangs generate-ttl.sh patch/apply.sh
  '';

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Monophonic Faust synth with vector synthesis, CZ-style oscillators and macro morphing (DPF: JACK/LV2/VST2/VST3/CLAP)";
    homepage = "https://github.com/magnetophon/DigiDrie";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "DigiDrie";
  };
})
