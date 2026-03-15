{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  llvmPackages,
  libx11,
  libxtst,
  libxdmcp,
  libxkbfile,
  libxkbcommon,
  libxcb,
  wayland,
  xorgproto,
}:
let
  venbindVersion = "0.1.7";
in
rustPlatform.buildRustPackage {
  pname = "venbind";
  version = venbindVersion;

  src = fetchFromGitHub {
    owner = "tuxinal";
    repo = "venbind";
    rev = "v${venbindVersion}";
    hash = "sha256-6gPyQ6JjqvM2AUuIxCfO0nOLJfyQTX5bbsbKDzlNSqo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-FZTXj8f+ezRhElovKhF3khWc5SqC+22tDHlFe9IHuwo=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    llvmPackages.libclang
    libx11
    libxtst
    libxdmcp
    libxkbfile
    libxkbcommon
    libxcb
    wayland
    xorgproto
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = lib.concatStringsSep " " [
    "-I${stdenv.cc.libc.dev}/include"
    "-I${xorgproto}/include"
    "-I${libx11.dev}/include"
    "-I${libxdmcp.dev}/include"
    "-I${libxcb.dev}/include"
    "-I${libxkbcommon.dev}/include"
    "-I${libxkbfile.dev}/include"
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    addon=$(find target -path "*/release/*" \( -name "*.node" -o -name "libvenbind.so" \) | head -n1)
    if [ -z "$addon" ]; then
      echo "venbind: native output not found" >&2
      exit 1
    fi

    mkdir -p $out
    cp "$addon" $out/venbind.node

    runHook postInstall
  '';
}
