{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  webkitgtk_4_0,
  zenity,
  Cocoa,
  Security,
  WebKit,
  withGui ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "alfis";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    rev = "v${version}";
    hash = "sha256-ettStNktSDZnYNN/IWqTB1Ou1g1QEGFabS4EatnDLaE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xe0YQCKnDV6M6IKWgljsuJ5ZevkdpxZDnNHAHKJyUec=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs =
    lib.optional stdenv.hostPlatform.isDarwin Security
    ++ lib.optional (withGui && stdenv.hostPlatform.isLinux) webkitgtk_4_0
    ++ lib.optionals (withGui && stdenv.hostPlatform.isDarwin) [
      Cocoa
      WebKit
    ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "doh" ] ++ lib.optional withGui "webgui";

  checkFlags = [
    # these want internet access, disable them
    "--skip=dns::client::tests::test_tcp_client"
    "--skip=dns::client::tests::test_udp_client"
  ];

  postInstall = lib.optionalString (withGui && stdenv.hostPlatform.isLinux) ''
    wrapProgram $out/bin/alfis \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    description = "Alternative Free Identity System";
    homepage = "https://alfis.name";
    changelog = "https://github.com/Revertron/Alfis/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = lib.platforms.unix;
    mainProgram = "alfis";
    broken = withGui && stdenv.hostPlatform.isDarwin;
  };
}
