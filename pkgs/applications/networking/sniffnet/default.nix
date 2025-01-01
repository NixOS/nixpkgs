{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libpcap
, libxkbcommon
, openssl
, stdenv
, alsa-lib
, expat
, fontconfig
, vulkan-loader
, wayland
, xorg
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffnet";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "gyulyvgc";
    repo = "sniffnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-wepy56LOhliU6t0ZRPviEbZtsWNqrtUnpUXsEdkRDqI=";
  };

  cargoHash = "sha256-cV3WhidnH2CBlmHa3IVHTQfTuPdSHwwY0XhgNPyLDN4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    expat
    fontconfig
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    rustPlatform.bindgenHook
  ];

  # requires internet access
  checkFlags = [
    "--skip=secondary_threads::check_updates::tests::fetch_latest_release_from_github"
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
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader xorg.libX11 libxkbcommon wayland ]}
  '';

  meta = with lib; {
    description = "Cross-platform application to monitor your network traffic with ease";
    homepage = "https://github.com/gyulyvgc/sniffnet";
    changelog = "https://github.com/gyulyvgc/sniffnet/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "sniffnet";
  };
}
