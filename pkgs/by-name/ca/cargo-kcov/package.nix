{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  kcov,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-kcov";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kennytm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hqplgj3i8js42v2kj44khk543a93sk3n6wlfpv3c84pdqlm29br";
  };

  cargoHash = "sha256-cgnTf4KKthO1HvjFCjoZw7eCTqsbobHW5Kjx/6V3r1Q=";
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-kcov \
        --prefix PATH : ${lib.makeBinPath [ kcov ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand to run kcov to get coverage report on Linux";
    mainProgram = "cargo-kcov";
    homepage = "https://github.com/kennytm/cargo-kcov";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      saschagrunert
      matthiasbeyer
    ];
  };
}
