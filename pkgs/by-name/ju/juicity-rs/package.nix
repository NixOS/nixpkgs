{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  libxcb,
  libxkbcommon,
  fontconfig,
  wayland,
  makeWrapper,
  libGL,
  vulkan-loader,
  testers,
  juicity-rs,
  withGui ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "juicity-rs";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "juicity";
    repo = "juicity-rs";
    tag = "v${version}";
    hash = "sha256-cN/AgMcI2yTAfNM8u9K4nDyEZX1l283m7Na/bF1MJyI=";
  };

  cargoHash = "sha256-nJsCtUozOppNVdlGcXbwh6s9MKxHAofeDzYZ0j5ptzM=";

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withGui [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals withGui [
    libxcb
    libxkbcommon
    fontconfig
    wayland
  ];

  cargoBuildFlags = [
    "--package"
    "juicity-client"
    "--package"
    "juicity-server"
  ]
  ++ lib.optionals withGui [
    "--package"
    "juicity-gui"
  ];

  cargoTestFlags = [
    "--package"
    "juicity-client"
    "--package"
    "juicity-server"
  ]
  ++ lib.optionals withGui [
    "--package"
    "juicity-gui"
  ];

  # See https://github.com/juicity/juicity-rs/pull/10
  patches = [
    ./disable-ksni-tokio.patch
  ];

  postFixup = lib.optionalString withGui ''
    wrapProgram $out/bin/juicity-gui \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
          libxcb
          fontconfig
          libGL
          vulkan-loader
        ]
      }
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = juicity-rs;
      command = "juicity-server -v";
      version = "v${version}";
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "A QUIC-based proxy tool (Rust rewrite of juicity)";
    homepage = "https://github.com/juicity/juicity-rs";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = if withGui then "juicity-gui" else "juicity-server";
  };
}
