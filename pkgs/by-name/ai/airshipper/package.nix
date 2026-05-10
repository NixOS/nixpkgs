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
  # Patch for airshipper to install veloren
  patch =
    let
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
      ];
    in
    writeShellScript "patch" ''
      echo "making binaries executable"
      chmod +x {veloren-voxygen,veloren-server-cli}
      echo "patching dynamic linkers"
      ${patchelf}/bin/patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        veloren-server-cli
      ${patchelf}/bin/patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        --set-rpath "${lib.makeLibraryPath runtimeLibs}" \
        veloren-voxygen
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
    libx11
    libxrandr
    libxi
    libxcursor
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
        libx11
        libxrandr
        libxi
        libxcursor
      ];
    in
    ''
      # We set LD_LIBRARY_PATH instead of using patchelf in order to propagate the libs
      # to both Airshipper itself as well as the binaries downloaded by Airshipper.
      wrapProgram "$out/bin/airshipper" \
        --set VELOREN_PATCHER "${patch}" \
        --prefix LD_LIBRARY_PATH : "${libPath}"
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
