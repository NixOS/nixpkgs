{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  apple-sdk_11,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  # Originally, this package was under the attribute `du-dust`, since `dust` was taken.
  # Since then, `dust` has been freed up, allowing this package to take that attribute.
  # However in order for tools like `nix-env` to detect package updates, keep `du-dust` for pname.
  pname = "du-dust";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    hash = "sha256-oaDJLDFI193tSzUDqQI/Lvrks0FLYTMLrrwigXwJ+rY=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/tests/test_dir_unicode/
    '';
  };

  cargoHash = "sha256-o9ynFkdx6a8kHS06NQN7BzWrOIxvdVwnUHmxt4cnmQU=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  doCheck = false;

  postInstall = ''
    installManPage man-page/dust.1
    installShellCompletion completions/dust.{bash,fish} --zsh completions/_dust
  '';

  meta = {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "dust";
  };
}
