{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  openssl,
  rust-jemalloc-sys-unprefixed,
  sqlite,
  vulkan-loader,
  wayland,
  iproute2,
  iptables,
  libglvnd,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  binPath = lib.makeBinPath [
    iproute2
    iptables
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geph5";
  version = "0.2.57";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "geph5";
    rev = "geph5-client-v${finalAttrs.version}";
    hash = "sha256-FArd+qiGBWjplAl/+jMdz5nIxqyPkI8+VNjv14C+0RA=";
  };

  cargoHash = "sha256-1FlQ4AjSZJol5woHcsYjTVY5vjpCudByXtWEAX1K0F4=";

  postPatch = ''
    substituteInPlace binaries/geph5-client/src/vpn/*.sh \
      --replace-fail 'PATH=' 'PATH=${binPath}:'
  '';

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys-unprefixed
    sqlite
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  buildFeatures = [
    "aws_lambda"
    "windivert"
  ];

  checkFlags = [
    # Wrong test
    "--skip=traffcount::tests::test_traffic_cleanup"
    # Requires network
    "--skip=dns::tests::resolve_google"
    # Never finish
    "--skip=tests::test_blind_sign"
    "--skip=tests::test_generate_secret_key"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Geph5";
      desktopName = "Geph5";
      icon = "geph5";
      exec = "geph5-client-gui";
      categories = [ "Network" ];
      comment = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    })
  ];

  postInstall = ''
    install -m 444 -D binaries/geph5-client-gui/icon.png $out/share/icons/hicolor/512x512/apps/geph5.png
  '';

  postFixup = ''
    # Add required but not explicitly requested libraries
    patchelf --add-rpath '${
      lib.makeLibraryPath [
        wayland
        libxkbcommon
        vulkan-loader
        libglvnd
      ]
    }' "$out/bin/geph5-client-gui"
  '';

  meta = {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://github.com/geph-official/geph5";
    changelog = "https://github.com/geph-official/geph5/releases/tag/geph5-client-v${finalAttrs.version}";
    mainProgram = "geph5-client";
    platforms = lib.platforms.unix;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
})
