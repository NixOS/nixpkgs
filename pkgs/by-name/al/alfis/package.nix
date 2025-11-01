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
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "Revertron";
    repo = "Alfis";
    tag = "v${version}";
    hash = "sha256-gRk4kvIV+5cCUFaJvGbTAR44678Twa28iMGZ75lJz2c=";
  };

  cargoHash = "sha256-Ge0+7ClXlJFT6CyluHF7k4stsX+KuYp/riro1pvrcKM=";

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
