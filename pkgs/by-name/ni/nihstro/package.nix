{
  lib,
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  ninja,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nihstro";
  version = "0-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "neobrain";
    repo = "nihstro";
    rev = "f4d8659decbfe5d234f04134b5002b82dc515a44";
    hash = "sha256-ZHgWyZFW7t2VTibH7WeuU8+I12bb95I9NcHI5s4U3VU=";
  };

  postPatch = ''
    # CMake 2.6 is deprecated and is no longer supported by CMake > 4
    # inline of https://github.com/neobrain/nihstro/pull/71
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" \
        "cmake_minimum_required(VERSION 3.5)"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ boost ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };
  };

  meta = {
    description = "3DS shader assembler and disassembler";
    homepage = "https://github.com/neobrain/nihstro";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "nihstro-assemble";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
