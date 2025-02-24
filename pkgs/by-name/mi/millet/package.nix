{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.14.7";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nj/ueMQSAqdcAG5jaSZBOHd4D4l7xD3i+LO9MUYsz0c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LFk51PL0r6YAlwXPthZIKe2DD5g9KZBSNCfdhhwWP10=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [
    "--package=millet-ls"
    "--package=millet-cli"
  ];

  cargoTestFlags = [
    "--package=millet-ls"
    "--package=millet-cli"
  ];

  meta = with lib; {
    description = "Language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/blob/v${version}/docs/CHANGELOG.md";
    license = [
      licenses.mit # or
      licenses.asl20
    ];
    maintainers = [ ];
    mainProgram = "millet-cli";
  };
}
