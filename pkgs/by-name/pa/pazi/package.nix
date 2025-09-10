{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "euank";
    repo = "pazi";
    rev = "v${version}";
    sha256 = "sha256-PDgk6VQ/J9vkFJ0N+BH9LqHOXRYM+a+WhRz8QeLZGiM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoHash = "sha256-/r/nRQ/7KyUmJK19F557AcxXEXa85E/CE6+YFU6DdR4=";

  postInstall = ''
    installManPage packaging/man/pazi.1
  '';

  meta = with lib; {
    description = "Autojump \"zap to directory\" helper";
    homepage = "https://github.com/euank/pazi";
    license = licenses.gpl3;
    maintainers = [ ];
    mainProgram = "pazi";
  };
}
