{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  darwin,
  pandoc,
  testers,
  lsd,
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "lsd-rs";
    repo = "lsd";
    rev = "v${version}";
    hash = "sha256-4vf68Rga2Z+PYIdfzzmDtfjCQVbr8RWiVG29c/UDVsQ=";
  };

  cargoHash = "sha256-R+mOpZQLY6VFfxhCSk2MZmoCRGT49knBH9k4C6Z6KuQ=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    pandoc --standalone --to man doc/lsd.md -o lsd.1
    installManPage lsd.1

    installShellCompletion --cmd lsd \
      --bash $releaseDir/build/lsd-*/out/lsd.bash \
      --fish $releaseDir/build/lsd-*/out/lsd.fish \
      --zsh $releaseDir/build/lsd-*/out/_lsd
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

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
