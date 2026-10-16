{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "playit-agent";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i+v1oyssmeOoMXcyJ8nnS0nTwfKJXXIiIu3KAXBzH1I=";
  };

  cargoHash = "sha256-Y29Ktb/Vpwdy988pm1PHWmHeHtfsiAGHQLpQ8AZo0L4=";

  checkFlags = [
    # these tests require network access
    "--skip=utils::name_lookup::test::test_lookup"
    "--skip=ping_tool::test::test_ping"
  ];

  meta = {
    description = "Tunnel client for playit.gg";
    homepage = "https://playit.gg";
    changelog = "https://github.com/playit-cloud/playit-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ maxicode ];
    mainProgram = "playit-cli";
    platforms = lib.platforms.all;
  };
})
