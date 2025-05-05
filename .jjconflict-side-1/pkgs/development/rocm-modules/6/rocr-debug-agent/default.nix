{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  clr,
  git,
  rocdbgapi,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocr-debug-agent";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocr_debug_agent";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-HYag5/E72hopDhS9EVcdyGgSvzbCMzKqLC+SIS28Y9M=";
  };

  nativeBuildInputs = [
    cmake
    clr
    git
  ];

  buildInputs = [
    rocdbgapi
    elfutils
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${clr}"
    "-DHIP_PATH=${clr}"
  ];

  # Weird install target
  postInstall = ''
    rm -rf $out/src
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Library that provides some debugging functionality for ROCr";
    homepage = "https://github.com/ROCm/rocr_debug_agent";
    license = with licenses; [ ncsa ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
