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
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hvwuqbeT4kbmBNVAQ+ij6rPmxS1Cp5Xv733h4oXeF20=";
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
