{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "routinator";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tgDhIM8Dw4k/ocXa3U1xqS/TDmqNbjnNzIyCxEmu294=";
  };

  cargoHash = "sha256-XOy8sm6nzmihFYsgLcusoYKwgTvx0qX8o8XWV4EMXZ8=";

  meta = {
    description = "RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };

  passthru.tests = {
    basic-functioniality = nixosTests.routinator;
  };
})
