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
  version = "0.26.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-nNoH5523EuDt+dbeFgOpMkbGS6P+Hk6Ck0FmariSFRs=";
  };

  buildNoDefaultFeatures = true;

  cargoHash = "sha256-G3bbAj3vo4dchq1AYoG4U/ST9JLiV2F4XjKCvYo48MI=";

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

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    mainProgram = "kubie";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
