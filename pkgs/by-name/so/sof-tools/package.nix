{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sof-tools";
  version = "2.14.2";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1LLpmcwz0NYhJ9eCeuQWCwjROPptS6MWq+LkkN4Bsek=";
  };

  postPatch = ''
    patchShebangs ../scripts/gen-uuid-reg.py
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [ alsa-lib ];
  sourceRoot = "${finalAttrs.src.name}/tools";

  meta = {
    description = "Tools to develop, test and debug SoF (Sund Open Firmware)";
    homepage = "https://thesofproject.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.johnazoidberg ];
    mainProgram = "sof-ctl";
  };
})
