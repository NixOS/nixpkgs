{
  lib,
  kubectl,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubie";
  version = "0.28.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-WVmr/P+7gr1efTruoRfRRFIAxH2TnG8xun7PaApXYOo=";
  };

  buildNoDefaultFeatures = true;

  cargoHash = "sha256-XKXULsdB4t5CPZVrkoT5H8Aj0AFhhnF31bR4s4dqe3A=";

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
})
