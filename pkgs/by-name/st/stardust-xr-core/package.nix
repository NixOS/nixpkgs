{
  lib,
  fetchFromGitHub,
  writeScript,
  unstableGitUpdater,
  rustPlatform,
  cargo,
  openxr-loader,
  libGL,
  mesa,
  xorg,
  fontconfig,
  libxkbcommon,
  libclang,
  cmake,
  cpm-cmake,
  pkg-config,
  llvmPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-core";
  version = "0-unstable-2024-06-06";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "core";
    rev = "a21dc0e610f6e7c905d42f80009700ff4474e583";
    hash = "sha256-1Bor53L+Fe18SU6MKwPLQXDGZq6E9++gtwDy4zkzZXw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "color-rs-0.8.0" = "sha256-/p4wYiLryY0+h0HBJUo4OV2jdZpcVn2kqv+8XewM4gM=";
    };
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  passthru.updateScript = writeScript "envision-update" ''
    source ${builtins.head (unstableGitUpdater { })}
    ${lib.getExe cargo} generate-lockfile --manifest-path $tmpdir/Cargo.toml
    cp $tmpdir/Cargo.lock ./pkgs/by-name/st/stardust-xr-core/Cargo.lock
  '';

  meta = {
    description = "A wayland compositor and display server for 3D applications";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.linux;
  };
}
