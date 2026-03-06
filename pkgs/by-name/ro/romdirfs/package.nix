{
  lib,
  gccStdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fuse,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "romdirfs";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mlafeldt";
    repo = "romdirfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5wHNL/9RcAVMUMyme9p25YkfyV/7V2wQLp/5TOetesk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ fuse ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "FUSE for access Playstation 2 IOP IOPRP images and BIOS dumps";
    homepage = "https://github.com/mlafeldt/romdirfs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "romdirfs";
  };
})
