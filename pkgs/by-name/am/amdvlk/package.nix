{
  stdenv,
  callPackage,
  lib,
  fetchRepoProject,
  nix-update-script,
  cmake,
  directx-shader-compiler,
  glslang,
  ninja,
  patchelf,
  perl,
  pkg-config,
  python3,
  expat,
  libdrm,
  ncurses,
  openssl,
  wayland,
  xorg,
  zlib,
}:
let

  suffix = if stdenv.system == "x86_64-linux" then "64" else "32";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdvlk";
  version = "2025.Q1.3";

  src = fetchRepoProject {
    name = "amdvlk-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${finalAttrs.version}";
    hash = "sha256-ZXou5g0emeK++NyV/hQllZAdZAMEY9TYs9c+umFdcfo=";
  };

  buildInputs = [
    expat
    libdrm
    ncurses
    openssl
    wayland
    zlib
  ]
  ++ (with xorg; [
    libX11
    libxcb
    xcbproto
    libXext
    libXrandr
    libXft
    libxshmfence
  ]);

  nativeBuildInputs = [
    cmake
    directx-shader-compiler
    glslang
    ninja
    patchelf
    perl
    pkg-config
    python3
  ]
  ++ (with python3.pkgs; [
    jinja2
    ruamel-yaml
  ]);

  rpath = lib.makeLibraryPath (
    [
      libdrm
      openssl
      stdenv.cc.cc
      zlib
    ]
    ++ (with xorg; [
      libX11
      libxcb
      libxshmfence
    ])
  );

  cmakeDir = "../drivers/xgl";

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/lib icd/amdvlk${suffix}.so
    install -Dm644 -t $out/share/vulkan/icd.d icd/amd_icd${suffix}.json
    install -Dm644 -t $out/share/vulkan/implicit_layer.d icd/amd_icd${suffix}.json

    patchelf --set-rpath "$rpath" $out/lib/amdvlk${suffix}.so

    runHook postInstall
  '';

  # Keep the rpath, otherwise vulkaninfo and vkcube segfault
  dontPatchELF = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "https://github.com/GPUOpen-Drivers/AMDVLK"
      "--version-regex"
      "v-(.*)"
    ];
  };

  passthru.impureTests = {
    amdvlk = callPackage ./test.nix { };
  };

  meta = {
    description = "AMD Open Source Driver For Vulkan";
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK";
    changelog = "https://github.com/GPUOpen-Drivers/AMDVLK/releases/tag/v-${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ Flakebi ];
  };
})
