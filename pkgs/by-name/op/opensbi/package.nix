{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  withPlatform ? "generic",
  withPayload ? null,
  withFDT ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensbi";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nD22UZfH0rJECHMDwd9ATyLz44cFHqcFH7N6piK8hog=";
  };

  postPatch = ''
    patchShebangs ./scripts
  '';

  nativeBuildInputs = [ python3 ];

  installFlags = [
    "I=$(out)"
  ];

  makeFlags = [
    "PLATFORM=${withPlatform}"
  ]
  ++ lib.optionals (withPayload != null) [
    "FW_PAYLOAD_PATH=${withPayload}"
  ]
  ++ lib.optionals (withFDT != null) [
    "FW_FDT_PATH=${withFDT}"
  ];

  enableParallelBuilding = true;

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "RISC-V Open Source Supervisor Binary Interface";
    homepage = "https://github.com/riscv-software-src/opensbi";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      ius
      nickcao
      zhaofengli
    ];
    platforms = [
      "riscv64-linux"
      "riscv32-linux"
    ];
  };
})
