{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmake,
  pkgsCross,
  wine64,
  mesa,
  pkg-config,
  libgbm,
  libdrm,
  vulkan-loader,
  pipewire,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spout2pw";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "hoshinolina";
    repo = "spout2pw";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    sha256 = "sha256-BpO5YkLPXHYubB4zFIIRo+uDcN/B6HWXyH6FUCF0T3s=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgsCross.mingwW64.buildPackages.gcc
    wine64
  ];

  depsBuildBuild = [
    pkg-config
    libgbm
    libdrm
    vulkan-loader
    pipewire
  ];

  patches = [
    ./0001-mesa.patch
    ./0002-pipewire.patch
    ./0003-spout2pw-path.patch
    ./0004-spout2pw-usage.patch
    ./0005-tools-package.patch
  ];

  postPatch = ''
    patchShebangs --build tools/get_wine_path.sh
    chmod +x tools/package.sh
    patchShebangs --build tools/package.sh
  '';

  mesonFlags = [
    "--cross-file=${finalAttrs.src}/misc/x86_64-w64-mingw32.txt"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/spout2pw/spout2pw.sh $out/bin/spout2pw
  '';

  postFixup = ''
    substituteInPlace $out/share/spout2pw/spout2pw.sh \
      --replace-fail '@MESA_PATH@' "${mesa}" \
      --replace-fail '@SPOUT2PW_PATH@' "$out"
  '';

  meta = {
    description = "Spout2 to PipeWire video bridge";
    homepage = "https://spout2pw.lina.yt/";
    mainProgram = "spout2pw";
    maintainers = with lib.maintainers; [
      liquidnya
    ];
    license = lib.licenses.lgpl21Plus;
  };
})
