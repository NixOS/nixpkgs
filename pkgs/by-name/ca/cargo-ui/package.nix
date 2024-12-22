{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  expat,
  fontconfig,
  libGL,
  xorg,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ui";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-M/ljgtTHMSc7rY/a8CpKGNuOSdVDwRt6+tzPPHdpKOw=";
  };

  cargoHash = "sha256-u3YqXQZCfveSBjxdWb+GC0IA9bpruAYQdxX1zanT3fw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      expat
      fontconfig
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      xorg.libxcb
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/cargo-ui \
      --add-rpath ${
        lib.makeLibraryPath [
          fontconfig
          libGL
        ]
      }
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "GUI for Cargo";
    mainProgram = "cargo-ui";
    homepage = "https://github.com/slint-ui/cargo-ui";
    changelog = "https://github.com/slint-ui/cargo-ui/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
      gpl3Only
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
