{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gs6uytX4rm2JrJ4UbtHJDg+b+Z1ZjcsuUR0b13jQIy4=";
  };

  cargoSha256 = "sha256-7zV/AsSZHk99ROC1301nkwJ22dvh4afeCI//G1zWHu8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage artifacts/mmtc.1
    installShellCompletion artifacts/mmtc.{bash,fish} --zsh artifacts/_mmtc
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    changelog = "https://github.com/figsoda/mmtc/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "mmtc";
  };
}
