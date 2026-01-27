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
  libX11,
  libXrandr,
  libXi,
  libXcursor,
  udev,
  alsa-lib,
  stdenv,
  libxcb,
  bzip2,
  cmake,
  fontconfig,
  freetype,
  pkg-config,
  makeWrapper,
  writeShellScript,
  patchelf,
}:
let
  version = "0.17.0";

  patchVoxygen =
    let
      runtimeLibs = [
        udev
        alsa-lib
        (lib.getLib stdenv.cc.cc)
        libxkbcommon
        libxcb
        libX11
        libXcursor
        libXrandr
        libXi
        vulkan-loader
        libGL
        wayland
        wayland-protocols
      ];
    in
    writeShellScript "patch-veloren-voxygen" ''
      echo "making veloren-voxygen executable"
      chmod +x veloren-voxygen
      echo "patching veloren-voxygen dynamic linker"
      ${patchelf}/bin/patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        --set-rpath "${lib.makeLibraryPath runtimeLibs}" \
        veloren-voxygen
    '';

  patchServerCLI = writeShellScript "patch-veloren-server-cli" ''
    echo "making veloren-server-cli executable"
    chmod +x veloren-server-cli
    echo "patching veloren-server-cli dynamic linker"
    ${patchelf}/bin/patchelf \
      --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
      veloren-server-cli
  '';
in
rustPlatform.buildRustPackage {
  pname = "airshipper";
  inherit version;

  src = fetchFromGitLab {
    owner = "Veloren";
    repo = "airshipper";
    tag = "v${version}";
    hash = "sha256-M89RswC08MZnNfk2T1+rtDajTpDGTnJoZ2U8bU5U2+0=";
  };

  cargoHash = "sha256-ry0hFvMDnotDQu6mqgyt+6hKOvGRJLmZKs3SxEVtDRg=";

  buildInputs = [
    fontconfig
    openssl
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXrandr
    libXi
    libXcursor
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  env.RUSTC_BOOTSTRAP = 1; # We need rust unstable features

  postInstall = ''
    install -Dm444 -t "$out/share/applications" "client/assets/net.veloren.airshipper.desktop"
    install -Dm444    "client/assets/net.veloren.airshipper.png"  "$out/share/icons/net.veloren.airshipper.png"
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        wayland-protocols
        bzip2
        fontconfig
        freetype
        libxkbcommon
        libX11
        libXrandr
        libXi
        libXcursor
        openssl
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/airshipper"
      wrapProgram "$out/bin/airshipper" \
        --set VELOREN_VOXYGEN_PATCHER "${patchVoxygen}" \
        --set VELOREN_SERVER_CLI_PATCHER "${patchServerCLI}"
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
}
