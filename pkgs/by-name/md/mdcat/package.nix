{
  lib,
  curl,
  oniguruma,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  asciidoctor,
  openssl,
  installShellFiles,
  makeWrapper,
  fzf,
  less,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "2.20.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BIRSAx2";
    repo = "mdcat";
    tag = "mdcat-${version}";
    hash = "sha256-w/kW6Kf7kb6XENXCxJeXgMNDpB0V9zZms2pnL7ksvHQ=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    installShellFiles
    makeWrapper
  ];
  buildInputs = [
    curl
    oniguruma
    openssl
  ];

  cargoHash = "sha256-et8vejUrS4ei6OZG30fBGY9pVS7kdrJpNXHbdWqEioE=";

  nativeCheckInputs = [
    # mdpick test pipes through `less -r`
    # Upstream fix: https://github.com/BIRSAx2/mdcat/pull/54
    # Can be removed when upstream is merged and released
    less
  ];

  postInstall = ''
    asciidoctor -b manpage -a reproducible -o mdcat.1 mdcat.1.adoc
    installManPage mdcat.1
    ln -s mdcat.1 $out/share/man/man1/mdless.1
    ln -s mdcat.1 $out/share/man/man1/mdpick.1
    ln -sr $out/bin/{mdcat,mdless}
    ln -sr $out/bin/{mdcat,mdpick}
    wrapProgram $out/bin/mdpick --suffix PATH : ${lib.makeBinPath [ fzf ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for bin in mdcat mdless mdpick; do
      installShellCompletion --cmd $bin \
        --bash <($out/bin/$bin --completions bash) \
        --fish <($out/bin/$bin --completions fish) \
        --zsh <($out/bin/$bin --completions zsh)
    done
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "mdcat-(.*)"
    ];
  };

  meta = {
    description = "cat for markdown";
    homepage = "https://github.com/BIRSAx2/mdcat";
    changelog = "https://github.com/BIRSAx2/mdcat/releases/tag/mdcat-${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      giomf
    ];
  };
}
