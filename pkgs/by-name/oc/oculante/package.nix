{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  fontconfig,
  nasm,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  libGL,
  libxkbcommon,
  wayland,
  stdenv,
  gtk3,
  perl,
  shaderc,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.9.2.1-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = "oculante";
    rev = "51b9f70b35e09850baee85971720b8d3ac49c80b";
    hash = "sha256-YTrUucO1Fq2TgnV/HHkx2fcHvBupeoMpiBSwqIvyHaQ=";
  };

  cargoHash = "sha256-Bn2HxmFiqOeb3oUnUL/K0SahcFWRlY9RrbGU4orQz+Y=";

  SHADERC_LIB_DIR = "${lib.getLib shaderc}/lib";

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
    perl
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    fontconfig
    shaderc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    gtk3
    libxkbcommon
    wayland
  ];

  checkFlags = [
    "--skip=bench"
    "--skip=tests::net" # requires network access
    "--skip=tests::flathub"
    "--skip=thumbnails::test_thumbs" # broken as of v0.9.2
  ];

  postInstall = ''
    install -Dm444 $src/res/icons/icon.png $out/share/icons/hicolor/128x128/apps/oculante.png
    install -Dm444 $src/res/oculante.desktop -t $out/share/applications
    wrapProgram $out/bin/oculante \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            libGL
            libxkbcommon
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland ]
        )
      }
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Minimalistic crossplatform image viewer written in Rust";
    homepage = "https://github.com/woelper/oculante";
    changelog = "https://github.com/woelper/oculante/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "oculante";
    maintainers = with lib.maintainers; [
      dit7ya
      figsoda
    ];
  };
}
