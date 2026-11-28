{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  pkg-config,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "routinator";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6X4hQDvFSxht2ehEk5h5n+gV5C+UqOyYFVccgmFwEro=";
  };

  cargoHash = "sha256-A4DbwsJrWBsHQqR3xteR974lui61c0OWBkj/d3I2ApI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ aws-lc ];

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
