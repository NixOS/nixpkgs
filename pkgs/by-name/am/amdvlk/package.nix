{
  stdenv,
  callPackage,
  lib,
  fetchRepoProject,
  writeScript,
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
  # Fix https://github.com/NixOS/nixpkgs/issues/348903 until the glslang update to 15.0.0 is merged into master
  glslang_fixed = glslang.overrideAttrs (finalAttrs: oldAttrs: { cmakeFlags = [ ]; });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "amdvlk";
  version = "2024.Q3.2";

  src = fetchRepoProject {
    name = "amdvlk-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${finalAttrs.version}";
    hash = "sha256-1Svdr93ShjhaWJUTLn5y1kBM4hHey1dUVDiHqFIKgrU=";
  };

  buildInputs =
    [
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

  nativeBuildInputs =
    [
      cmake
      directx-shader-compiler
      glslang_fixed
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
      stdenv.cc.cc.lib
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

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p coreutils curl gnused jq common-updater-scripts

    packagePath="pkgs/by-name/am/amdvlk/package.nix"

    function setHash() {
      sed -i $packagePath -e 's,sha256 = "[^'"'"'"]*",sha256 = "'"$1"'",'
    }

    version="$(curl -sL "https://api.github.com/repos/GPUOpen-Drivers/AMDVLK/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    sed -i $packagePath -e 's/version = "[^'"'"'"]*"/version = "'"$version"'"/'

    setHash "$(nix-instantiate --eval -A lib.fakeSha256 | xargs echo)"
    hash="$(nix to-base64 $(nix-build -A amdvlk 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true))"
    setHash "$hash"
  '';

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
