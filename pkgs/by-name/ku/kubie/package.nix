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
  version = "0.27.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-1qGNJoEB8Tlf/eKGNUy1OVKnDVHmrGnZFTPIP7GDPcw=";
  };

  buildNoDefaultFeatures = true;

  cargoHash = "sha256-3vWA3Xr1gfM+LZgFNWmRAyrCGP2dZOr7qUAt996PBTM=";

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
