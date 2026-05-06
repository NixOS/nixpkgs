{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,

  gitMinimal,
  libgit2,
  openssl,
  pkg-config,
  zlib,

  # according to README blogtato can be used almost entirely without jq
  jq ? null,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blogtato";
  version = "0.1.24";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "kantord";
    repo = "blogtato";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lzefjInuGariix6BOSjgXCD1dR5IJcZhE1VegTuURG8=";
  };

  cargoHash = "sha256-AZXqyF6LxBLWRo8mMPgdXZ9AK/2b8nv292O6xHQRUUc=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (jq != null) [ makeWrapper ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env.OPENSSL_NO_VENDOR = 1;

  nativeCheckInputs = [ gitMinimal ] ++ lib.optionals (jq != null) [ jq ];

  checkFlags = lib.optionals (jq == null) [
    # these tests rely on jq in PATH
    "--skip=utils::jq::tests::"
    "--skip=test_ingest_filter_readme_examples"
  ];

  # yes, this uses both libgit2 and the git cli
  postInstall = ''
    wrapProgram $out/bin/blog \
      --prefix PATH : "${lib.makeBinPath ([ gitMinimal ] ++ lib.optionals (jq != null) [ jq ])}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI RSS/Atom feed reader inspired by Taskwarrior";
    homepage = "https://github.com/kantord/blogtato";
    changelog = "https://github.com/kantord/blogtato/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "blog";
  };
})
