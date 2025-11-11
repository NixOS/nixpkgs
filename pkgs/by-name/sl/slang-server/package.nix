{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  catch2_3,
  cmake,
  ninja,
  fmt_12,
  mimalloc,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slang-server";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hudson-trading";
    repo = "slang-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L/L0jhaqWnwZVt1GWzJYa1/Ztx/c/oPKGw+P8CJQTuI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace external/slang/external/CMakeLists.txt --replace-fail \
      'set(mimalloc_min_version "2.2")' \
      'set(mimalloc_min_version "${lib.versions.majorMinor mimalloc.version}")'
  '';

  nativeBuildInputs = [
    cmake
    python3
    ninja
  ];

  buildInputs = [
    boost
    fmt_12
    mimalloc
    catch2_3
  ];

  strictDeps = true;

  meta = {
    description = "A SystemVerilog language server based on the Slang library.";
    homepage = "https://hudson-trading.github.io/slang-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hugom ];
    mainProgram = "slang-server";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
