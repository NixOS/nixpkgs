{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gs6uytX4rm2JrJ4UbtHJDg+b+Z1ZjcsuUR0b13jQIy4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TpAl7lMaQGSH9oMNqYIxnajsfh1HAdyU2suSFRfWYPs=";

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
