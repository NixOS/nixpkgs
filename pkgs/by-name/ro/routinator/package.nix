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
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ypdbZgIJDP+VX9iKPYUck4eJvw066N8X0GRjPrHjuX0=";
  };

  cargoHash = "sha256-ljIe4O2D66wUDTR/hZO+8OFR7qeF5D/qVaZSlf3BZ1g=";

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
