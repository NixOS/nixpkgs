{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  webkitgtk_4_1,
  zenity,
  withGui ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "alfis";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    tag = "v${version}";
    hash = "sha256-ettStNktSDZnYNN/IWqTB1Ou1g1QEGFabS4EatnDLaE=";
  };

  cargoHash = "sha256-xe0YQCKnDV6M6IKWgljsuJ5ZevkdpxZDnNHAHKJyUec=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optional (withGui && stdenv.hostPlatform.isLinux) webkitgtk_4_1;

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
    # needs libsoup-2.4, which is soon going to be removed
    # https://github.com/NixOS/nixpkgs/pull/450065
    broken = withGui;
  };
}
