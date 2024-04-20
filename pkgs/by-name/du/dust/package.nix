{ stdenv, lib, fetchFromGitHub, rustPlatform, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  # Originally, this package was under the attribute `du-dust`, since `dust` was taken.
  # Since then, `dust` has been freed up, allowing this package to take that attribute.
  # However in order for tools like `nix-env` to detect package updates, keep `du-dust` for pname.
  pname = "du-dust";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    hash = "sha256-KTsB9QqcLafG2XNj8PdkzwVrFDmpBQzNyDLajT/JDz0=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-d6Mnuo6JlbuHUGz+UCmC8jvNks3SpeP/aNQGXHBzB+8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  doCheck = false;

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "dust";
  };
}
