{
  lib,
  rustPlatform,
  fetchFromGitLab,
  openssl,
  libGL,
  vulkan-loader,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libx11,
  libxrandr,
  libxi,
  libxcursor,
  udev,
  alsa-lib,
  stdenv,
  libxcb,
  pkg-config,
  makeWrapper,
  writeShellScript,
  patchelf,
}:
let
  # Patch for airshipper to install veloren client
  patchVoxygen =
    runtimeLibs:
    writeShellScript "voxygen-patch" ''
      echo "making veloren-voxygen executable"
      chmod +x veloren-voxygen
      echo "patching veloren-voxygen dynamic linker"
      ${patchelf}/bin/patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        --set-rpath "${lib.makeLibraryPath runtimeLibs}" \
        veloren-voxygen
    '';
  # Patch for airshipper to install veloren server
  patchServer = writeShellScript "server-cli-patch" ''
    echo "making veloren-server-cli executable"
    chmod +x veloren-server-cli
    echo "patching veloren-server-cli dynamic linker"
    ${patchelf}/bin/patchelf \
      --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
      veloren-server-cli
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "airshipper";
  version = "0.17.0";

  src = fetchFromGitLab {
    owner = "Veloren";
    repo = "airshipper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M89RswC08MZnNfk2T1+rtDajTpDGTnJoZ2U8bU5U2+0=";
  };

  cargoHash = "sha256-ry0hFvMDnotDQu6mqgyt+6hKOvGRJLmZKs3SxEVtDRg=";

  buildInputs = [
    openssl
    wayland
    wayland-protocols
    libxkbcommon
    libx11
    libxrandr
    libxi
    libxcursor
    vulkan-loader
    libGL
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  env.RUSTC_BOOTSTRAP = 1; # We need rust unstable features

  postInstall = ''
    install -Dm444 -t "$out/share/applications" "client/assets/net.veloren.airshipper.desktop"
    install -Dm444    "client/assets/net.veloren.airshipper.png"  "$out/share/icons/net.veloren.airshipper.png"
  '';

  passthru = {
    inherit patchVoxygen patchServer;
    runtimeLibs = [
      udev
      alsa-lib
      (lib.getLib stdenv.cc.cc)
      libxkbcommon
      libxcb
      libx11
      libxcursor
      libxrandr
      libxi
      vulkan-loader
      libGL
      wayland
      wayland-protocols
    ];
  };

  postFixup = ''
    ${patchelf}/bin/patchelf \
      --set-rpath ${
        lib.makeLibraryPath (
          finalAttrs.buildInputs
          ++ [
            (lib.getLib stdenv.cc.cc)
            stdenv.cc.libc
          ]
        )
      } "$out/bin/airshipper"
    wrapProgram "$out/bin/airshipper" \
      --set VELOREN_VOXYGEN_PATCHER "${finalAttrs.passthru.patchVoxygen finalAttrs.passthru.runtimeLibs}" \
      --set VELOREN_SERVER_CLI_PATCHER "${finalAttrs.passthru.patchServer}"
  '';

  doCheck = false;
  cargoBuildFlags = [
    "--package"
    "airshipper"
  ];
  cargoTestFlags = [
    "--package"
    "airshipper"
  ];

  meta = {
    description = "Provides automatic updates for the voxel RPG Veloren";
    mainProgram = "airshipper";
    homepage = "https://www.veloren.net";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ yusdacra ];
  };
})
