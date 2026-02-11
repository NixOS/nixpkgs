{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  fontconfig,
  nasm,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
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
    libx11
    libxcursor
    libxi
    libxrandr
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

  patches = [
    # The below patch is needed to fix this build, until the upstream dependency (libavif-rs) fixes the problem.
    # The explicit `patchFlags` can also be removed when this patch becomes obsolete.
    # <https://github.com/njaard/libavif-rs/issues/122>
    ./libaom-sys-0.17.2+libaom.3.11.0-cmake-nasm-fix.patch
  ];

  patchFlags = [
    "-p1"
    "--directory=../${pname}-${version}-vendor"
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
    ];
  };
}
