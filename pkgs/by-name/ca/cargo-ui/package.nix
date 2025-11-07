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
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ui";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-M/ljgtTHMSc7rY/a8CpKGNuOSdVDwRt6+tzPPHdpKOw=";
  };

  cargoHash = "sha256-odcyKOveYCWQ35uh//s19Jtq7OqiUnkeqbh90VWHp9A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
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

  meta = {
    description = "GUI for Cargo";
    mainProgram = "cargo-ui";
    homepage = "https://github.com/slint-ui/cargo-ui";
    changelog = "https://github.com/slint-ui/cargo-ui/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}
