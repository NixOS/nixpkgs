{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  srcOnly,
  cpm-cmake,
  cmake,
  python3,
  libGL,
  spirv-cross,
  spirv-headers,
  spirv-tools,
  glslang,
  xorg,
}:

stdenv.mkDerivation {
  pname = "sk_gpu";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "StereoKit";
    repo = "sk_gpu";
    rev = "84a9d14105ffa371defb92c52e4c51a3b0f1acd5";
    hash = "sha256-OkwTqVXU9nwUd+eMcgYKo0C72YS7I5FW/xb3z4ldo1w=";
  };

  postPatch = ''
    install -D ${cpm-cmake}/share/cpm/CPM.cmake /build/source/build/cmake/CPM_0.38.7.cmake
  '';

  cmakeFlags = [
    (lib.cmakeBool "SK_BUILD_SHADERC" true)
    (lib.cmakeBool "SK_BUILD_EDITOR" false) # currently depends on windows-only APIs (windows.h, tchar.h)
    (lib.cmakeBool "SK_BUILD_EXAMPLES" true)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    python3
    cmake
  ];
  buildInputs = [
    libGL
    spirv-cross
    spirv-headers
    spirv-tools
    # TODO: There's got to be a better way to do this
    glslang
    (runCommand "glslang-standalone-headers" { } ''
      mkdir -p $out/include/StandAlone
      cp ${srcOnly glslang}/StandAlone/DirStackFileIncluder.h $out/include/StandAlone/DirStackFileIncluder.h
      substituteInPlace $out/include/StandAlone/DirStackFileIncluder.h \
        --replace-fail '"./../glslang/Public/ShaderLang.h"' '<glslang/Public/ShaderLang.h>'
    '')
    glslang
    xorg.libX11
  ];
}
