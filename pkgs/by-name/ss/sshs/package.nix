{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  sshs,
}:

rustPlatform.buildRustPackage rec {
  pname = "sshs";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = "sshs";
    rev = version;
    hash = "sha256-QFWrjmEBAhk0aHZh72DnPXJXYJWiRVF9v0A8y/79/ls=";
  };

  cargoHash = "sha256-KfrWXWpyuqpJ7WiBscLg7Q4d3XqBw/DjyfYjau01bL8=";

  passthru.tests.version = testers.testVersion { package = sshs; };

  meta = {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ not-my-segfault ];
    mainProgram = "sshs";
  };
}
