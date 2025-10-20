{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  bash-completion,
  pkg-config,
  libconfig,
  asciidoc,
  libusbgx,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gt";
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "gt";
    rev = "8ebbf3eb6fb77a53d6ace0eebf4f5debb779b576";
    sha256 = "sha256-f/1nYnpAJ22ilWeyGtGcz9ZynL8a4UQoiKW+K/97iRI=";
  };

  sourceRoot = "${finalAttrs.src.name}/source";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  preConfigure = ''
    cmakeFlagsArray+=("-DBASH_COMPLETION_COMPLETIONSDIR=$out/share/bash-completions/completions")
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    asciidoc
  ];

  buildInputs = [
    bash-completion
    libconfig
    libusbgx
  ];

  meta = {
    description = "Linux command line tool for setting up USB gadgets using configfs";
    homepage = "https://github.com/linux-usb-gadgets/gt";
    mainProgram = "gt";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
