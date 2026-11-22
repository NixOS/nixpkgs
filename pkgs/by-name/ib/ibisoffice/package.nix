{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  fontconfig,
  freetype,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libglvnd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "ibisoffice";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "ibisjp";
    repo = "ibis-office";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-xywdNB5sojzkOJsp6fTYK3qrELQ+uzWt6jp0TZUHsmI=";
  };
  cargoHash = "sha256-jUee0wHppCZA2QWPfR5O6eyVbbCycCAnGz5asK4CFuI=";

  cargoBuildFlags = [
    "-p"
    "ibis-office-app"
  ];
  # The app tests enable DOCX scenarios that include fixtures omitted from the public release.
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    fontconfig
    freetype
    libxcb
    libxkbcommon
    wayland
  ];

  env = {
    CARGO_PROFILE_RELEASE_INCREMENTAL = "false";
    CARGO_PROFILE_RELEASE_LTO = "false";
  };

  postInstall = ''
    install -Dm644 crates/ibis-office-app/linux/ibisoffice.desktop \
      "$out/share/applications/ibisoffice.desktop"
    install -Dm644 crates/ibis-office-app/linux/jp.ne.ibis.ibisOffice.metainfo.xml \
      "$out/share/metainfo/jp.ne.ibis.ibisOffice.metainfo.xml"
    for size in 16 24 32 48 256; do
      install -Dm644 "crates/ibis-office-shell/logo/png/ico/ibisOffice_icon_win_''${size}px_transparent.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/ibisoffice.png"
    done
    install -Dm644 -t "$out/share/ibisOffice/artborders" \
      crates/ibis-formats/data/artborders/{OfficeOpenXML-WordprocessingMLArtBorders.zip,ECMA-NOTICE.txt}
    install -Dm644 -t "$out/share/doc/ibisOffice" LICENSE NOTICE COMMERCIAL-LICENSE.md
    install -Dm644 crates/ibis-office-app/linux/license.md "$out/share/doc/ibisOffice/third-party-licenses.md"
    install -Dm644 crates/ibis-office-render/fonts/carlito/OFL.txt "$out/share/doc/ibisOffice/Carlito-OFL.txt"
    wrapProgram "$out/bin/ibisOffice" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libglvnd
          vulkan-loader
          wayland
        ]
      }"
  '';

  meta = {
    description = "Office suite for documents, spreadsheets, and presentations";
    homepage = "https://github.com/ibisjp/ibis-office";
    license = lib.licenses.agpl3Only;
    mainProgram = "ibisOffice";
    maintainers = [ lib.maintainers.masanork ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
