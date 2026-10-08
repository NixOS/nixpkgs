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
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trasta298";
    repo = "keifu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bHKOItxZQk9sY1p3sxANJgor7QPRvanAA9OL370Ybbs=";
  };

  cargoHash = "sha256-qS9kSj7SaDtKJx3Zv5u4Xe0q0fzkRWbVv0fHSyjxVYc=";

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
