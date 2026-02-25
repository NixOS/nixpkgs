{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  installShellFiles,
  openssl,
  alsa-lib,
  didyoumean,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "charcoal";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "LighghtEeloo";
    repo = "charcoal";
    rev = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  postInstall = ''
    wrapProgram $out/bin/charcoal \
      --prefix PATH : ${lib.makeBinPath [ didyoumean ]}

    installShellCompletion --cmd charcoal \
      --bash completions/charcoal.bash \
      --fish completions/charcoal.fish \
      --zsh completions/_charcoal
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line dictionary using youdao dict API";
    homepage = "https://github.com/LighghtEeloo/charcoal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gorgeous-patrick ];
    mainProgram = "charcoal";
  };
})
