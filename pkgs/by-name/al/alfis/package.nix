{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libayatana-appindicator,
  webkitgtk_4_1,
  xdotool,
  zenity,
  withGui ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alfis";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gYy4Jyq4tkAPPfi2GGUf0ucVPlTgr0PkZYdOmqUMBvU=";
  };

  cargoHash = "sha256-yRJSgFIheWLWK0gN9VNmgMhQGdv902zx2T3X6CA8YEQ=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals (withGui && stdenv.hostPlatform.isLinux) [
    webkitgtk_4_1
    xdotool
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "doh" ] ++ lib.optional withGui "webgui";

  checkFlags = [
    # these want internet access, disable them
    "--skip=dns::client::tests::test_tcp_client"
    "--skip=dns::client::tests::test_udp_client"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  postInstall = lib.optionalString (withGui && stdenv.hostPlatform.isLinux) ''
    wrapProgram $out/bin/alfis \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    description = "Alternative Free Identity System";
    homepage = "https://alfis.name";
    changelog = "https://github.com/Revertron/Alfis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = lib.platforms.unix;
    mainProgram = "alfis";
  };
})
