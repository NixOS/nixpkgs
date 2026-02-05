{
  lib,
  kubectl,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.26.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-eSzNCH0MiGvLKHrSXFSXQq4lN5tfmr0NcuGaN96Invs=";
  };

  buildNoDefaultFeatures = true;

  cargoHash = "sha256-nXzIXMpCtibTN4rsPQFtSSjCQzylWWQZixwbH680ue0=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installShellCompletion completion/kubie.{bash,fish}

    wrapProgram "$out/bin/kubie" \
      --prefix PATH : "${
        lib.makeBinPath [
          kubectl
        ]
      }"
  '';

  meta = {
    description = "Shell independent context and namespace switcher for kubectl";
    mainProgram = "kubie";
    homepage = "https://github.com/sbstp/kubie";
    license = with lib.licenses; [ zlib ];
    maintainers = with lib.maintainers; [ illiusdope ];
  };
}
