{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  sshs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sshs";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = "sshs";
    rev = finalAttrs.version;
    hash = "sha256-pC1UmnE0ePs5I+qUwWJO/heX781JueirXwtef1m6CTQ=";
  };

  cargoHash = "sha256-SpiJ0WUDmxoqoVbuRh/Kzu3urvhdsm/UZdJdrJ3pP/g=";

  passthru.tests.version = testers.testVersion { package = sshs; };

  meta = {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ not-my-segfault ];
    mainProgram = "sshs";
  };
})
