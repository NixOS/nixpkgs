{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  spirv-headers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sirit";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "eden-emulator";
    repo = "sirit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eiuAdnPBJAMCRbkwJkqjyaskBCa2/Cm0F3gqFwe3ePg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [ spirv-headers ];

  cmakeFlags = [
    (lib.cmakeBool "SIRIT_USE_SYSTEM_SPIRV_HEADERS" true)
  ];

  meta = {
    description = "Runtime SPIR-V assembler";
    homepage = "https://github.com/eden-emulator/sirit";
    license = with lib.licenses; [
      agpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.linux;
  };
})
