{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pandoc,
  installShellFiles,
  fontconfig,
  freetype,
  libgit2,
  libxkbcommon,
  sqlite,
  vulkan-loader,
  zlib,
  stdenv,
  wayland,
  libx11,
  libxcb,
  nix-update-script,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "numnum";
  version = "0.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rudrabhoj";
    repo = "numnum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1+eWjFxfgytIPs04Kt3pQtv0n1NliMbJDsT8uedeLIA=";
  };

  cargoHash = "sha256-CByqjxinuEcuSBUnO4nolnReYBDMgQND8xIvCqjVdg8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
    pandoc
    installShellFiles
  ];

  buildInputs = [
    fontconfig
    freetype
    libgit2
    libxkbcommon
    sqlite
    vulkan-loader
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
    libx11
    libxcb
  ];

  env = {
    LIBGIT2_NO_VENDOR = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  postInstall = ''
    install -Dm644 packaging/numnum.desktop -t $out/share/applications/
    install -Dm644 assets/icons/numnum.svg $out/share/icons/hicolor/scalable/apps/numnum.svg

    pandoc -s -f markdown -t man README.md -M title="NUMNUM" -M section="1" -o numnum.1
    pandoc -s -f markdown -t man grammar_notes.md -M title="NUMNUM-GRAMMAR" -M section="7" -o numnum-grammar.7

    installManPage numnum.1 numnum-grammar.7
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/numnum \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          vulkan-loader
          libxkbcommon
          libx11
          libxcb
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazingly fast GPU rendered open source alternative to Numi. It is a notebook calculator that understands maths in plain english. Built with Rust and GPUI";
    homepage = "https://github.com/rudrabhoj/numnum";
    changelog = "https://github.com/rudrabhoj/numnum/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ lnk3 ];
    mainProgram = "numnum";
  };
})
