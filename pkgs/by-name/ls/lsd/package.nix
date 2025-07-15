{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pandoc,
  testers,
  lsd,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "lsd-rs";
    repo = "lsd";
    rev = "v${version}";
    hash = "sha256-LlMcBMb40yN+rlvGVsh7JaC3j9sF60YxitQQXe1q/oI=";
  };

  cargoHash = "sha256-yOJKXfPtzaYF012YCyW3m+9ffag4En4ZfTaiVh/85dM=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postInstall = ''
    pandoc --standalone --to man doc/lsd.md -o lsd.1
    installManPage lsd.1

    installShellCompletion --cmd lsd \
      --bash $releaseDir/build/lsd-*/out/lsd.bash \
      --fish $releaseDir/build/lsd-*/out/lsd.fish \
      --zsh $releaseDir/build/lsd-*/out/_lsd
  '';

  nativeCheckInputs = [ git ];

  passthru.tests.version = testers.testVersion { package = lsd; };

  meta = {
    homepage = "https://github.com/lsd-rs/lsd";
    description = "Next gen ls command";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      zowoq
      SuperSandro2000
    ];
    mainProgram = "lsd";
  };
}
