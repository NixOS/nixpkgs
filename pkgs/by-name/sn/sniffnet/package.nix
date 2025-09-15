{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  libpcap,
  openssl,
  alsa-lib,
  expat,
  fontconfig,
  vulkan-loader,
  xorg,

  # wrapper
  libxkbcommon,
  wayland,

  # tests
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sniffnet";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "gyulyvgc";
    repo = "sniffnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EgnFDF+K8qGjunWB20VA8bXLzNvyGzcIaim+smhW5fU=";
  };

  cargoHash = "sha256-22P1EeZ2FqwIHjr23oJCKvg3ggT1Me93goELwZ/B9S4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    expat
    fontconfig
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];

  # requires internet access
  checkFlags = [
    "--skip=secondary_threads::check_updates::tests::fetch_latest_release_from_github"
    "--skip=utils::check_updates::tests::fetch_latest_release_from_github"
  ];

  postInstall = ''
    for res in $(ls resources/packaging/linux/graphics | sed -e 's/sniffnet_//g' -e 's/x.*//g'); do
      install -Dm444 resources/packaging/linux/graphics/sniffnet_''${res}x''${res}.png \
        $out/share/icons/hicolor/''${res}x''${res}/apps/sniffnet.png
    done
    install -Dm444 resources/packaging/linux/sniffnet.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/sniffnet.desktop \
      --replace 'Exec=/usr/bin/sniffnet' 'Exec=sniffnet'
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/sniffnet \
      --add-rpath ${
        lib.makeLibraryPath [
          vulkan-loader
          xorg.libX11
          libxkbcommon
          wayland
        ]
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Cross-platform application to monitor your network traffic with ease";
    homepage = "https://github.com/gyulyvgc/sniffnet";
    changelog = "https://github.com/gyulyvgc/sniffnet/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    teams = [ lib.teams.ngi ];
    mainProgram = "sniffnet";
  };
})
