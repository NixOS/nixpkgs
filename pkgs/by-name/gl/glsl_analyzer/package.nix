{ lib
, stdenv
, fetchgit
, zig_0_11
, gitMinimal
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glsl_analyzer";
  version = "1.4.4";

  src = fetchgit {
    url = "https://github.com/nolanderc/glsl_analyzer.git";
    leaveDotGit = true;
    rev = "v${finalAttrs.version}";
    hash = "sha256-7Td5cTn4K/HJz5BHEmWdrX+YdRcPSSSOCPvYRPD3g0g=";
  };

  patches = [ ./zig11-compatibility.patch ];

  nativeBuildInputs = [
    zig_0_11.hook
    gitMinimal
  ];

  meta = {
    description = "Language server for GLSL (OpenGL Shading Language).";
    changelog = "https://github.com/nolanderc/glsl_analyzer/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/nolanderc/glsl_analyzer";
    mainProgram = "glsl_analyzer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wr7 ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})
