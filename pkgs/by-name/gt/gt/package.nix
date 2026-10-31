{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libconfig,
  asciidoc,
  libusbgx,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gt";
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "gt";
    rev = "8ebbf3eb6fb77a53d6ace0eebf4f5debb779b576";
    hash = "sha256-f/1nYnpAJ22ilWeyGtGcz9ZynL8a4UQoiKW+K/97iRI=";
  };

  sourceRoot = "${finalAttrs.src.name}/source";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  cmakeFlags = [
    (lib.cmakeFeature "BASH_COMPLETION_COMPLETIONSDIR" "${placeholder "out"}/share/bash-completion/completions")
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    asciidoc
  ];

  buildInputs = [
    libconfig
    libusbgx
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/linux-usb-gadgets/gt";
    description = "CLI tool for setting up USB gadgets using configfs";
    mainProgram = "gt";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
