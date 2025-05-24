{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "pet";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-B0ilobUlp6UUXu6+lVqIHkbFnxVu33eXZFf+F7ODoQU=";
  };

  vendorHash = "sha256-+ieBk7uMzgeM45uvLfljenNvhGVv1mEazErf4YHPNWQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/knqyf263/pet/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pet \
      --bash <($out/bin/pet completion bash) \
      --fish <($out/bin/pet completion fish) \
      --zsh $src/misc/completions/zsh/_pet
  '';

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    mainProgram = "pet";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
