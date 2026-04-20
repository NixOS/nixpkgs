{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oaknut";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "eden-emulator";
    repo = "oaknut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NWJMottKMiG6Rk2/ACNtBiYfWDsCeSGznPTqVO809P0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "Header-only library that allows one to dynamically assemble code in-memory at runtime";
    homepage = "https://github.com/eden-emulator/oaknut";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
