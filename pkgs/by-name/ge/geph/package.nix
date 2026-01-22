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
  nix-update-script,
}:
let
  binPath = lib.makeBinPath [
    iproute2
    iptables
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geph5";
  version = "0.2.86";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "geph5";
    rev = "geph5-client-v${finalAttrs.version}";
    hash = "sha256-68b6czefoqLskdqhc9kDIoS8eDCKu56lqvX8Jz47C3k=";
  };

  cargoHash = "sha256-CoYnP83Ci5Jp3Hunm2+xdXBu0mlhADf4jyfLSIXZ0jI=";

  postPatch = ''
    substituteInPlace binaries/geph5-client/src/vpn/*.sh \
      --replace-fail 'PATH=' 'PATH=${binPath}:'

    # This setting is dumped from https://github.com/geph-official/gephgui-wry/blob/a85a632448e548f69f9d1eea3d06a4bdc8be3d57/src/daemon.rs#L230
    cat ${./settings_default.yaml} | base32 -w 0  | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567' '0123456789ABCDEFGHJKMNPQRSTVWXYZ' | sed 's/=//g' > binaries/geph5-client-gui/src/settings_default.yaml.base32
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
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
  };

  buildFeatures = [
    "aws_lambda"
    "windivert"
  ];

  checkFlags = [
    # Wrong test
    "--skip=traffcount::tests::test_traffic_count_basic"
    # Requires network
    "--skip=dns::tests::resolve_google"
    # Never finish
    "--skip=tests::test_blind_sign"
    "--skip=tests::test_generate_secret_key"
    "--skip=tests::ping_pong"
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "geph5-client-v(.*)"
    ];
  };

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
