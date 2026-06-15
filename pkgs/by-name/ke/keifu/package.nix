{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  makeWrapper,
  gitMinimal,
  stdenv,
  libiconv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keifu";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trasta298";
    repo = "keifu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-668ejr2pxjGfQ0/hhJSNBSZME2+hSGuNJmwmbLVqy0o=";
  };

  cargoHash = "sha256-6YmpsKkf/Mox98fRdrwbwzFohgOicRfCxcAIGSwmT7g=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    wrapProgram $out/bin/keifu \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A TUI tool to visualize Git commit graphs with branch genealogy";
    homepage = "https://github.com/trasta298/keifu";
    changelog = "https://github.com/trasta298/keifu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      usu171
    ];
    mainProgram = "keifu";
    platforms = lib.platforms.unix;
  };
})
