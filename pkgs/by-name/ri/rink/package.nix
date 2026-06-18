{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  ncurses,
  curl,
  installShellFiles,
  asciidoctor,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.9.0";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JRXRN/jOwM3j59ckOcIlbLdSvV9PFueOPs/EVHCF8JE=";
  };

  cargoHash = "sha256-qbMnJjJQbNqs6AAgMjtqPEMxIDxdF5a8/tWAVW0Vrig=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    asciidoctor
  ];
  buildInputs = [
    ncurses
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [
        curl
        libiconv
      ]
    else
      [ openssl ]
  );

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  postBuild = ''
    make man
  '';

  postInstall = ''
    installManPage build/*
  '';

  meta = {
    description = "Unit-aware calculator";
    mainProgram = "rink";
    homepage = "https://rinkcalc.app";
    license = with lib.licenses; [
      mpl20
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [
      sb0
    ];
  };
})
