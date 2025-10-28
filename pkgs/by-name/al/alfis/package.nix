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
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    tag = "v${version}";
    hash = "sha256-u5luVJRNIuGqqNyh+C7nMSkZgoq/S7gpmsEiz8ntmC4=";
  };

  cargoHash = "sha256-ittJ/iKcmvd5r8oaBoGhi/E2osq245OWxSC+VH+bme4=";

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
  };
}
