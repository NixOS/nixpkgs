{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "asdf-vm";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "asdf-vm";
    repo = "asdf";

    tag = "v${finalAttrs.version}";
    hash = "sha256-BBd+MiRISjMz2m29nNIakG79Oy1k7bZI/Q24QQNp5CY=";

  };

  vendorHash = "sha256-gzlHXIzDYo4leP+37HgNrz5faIlrCLYA7AVSvZ6Uicc=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # Tests have additional requirements
  doCheck = false;

  postInstall = ''
    # Install profile.d script for environment setup
    mkdir -p $out/etc/profile.d
    cat > $out/etc/profile.d/asdf-prepare.sh <<'EOF'
    export ASDF_DIR="${placeholder "out"}"
    export PATH="''${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
    EOF

    # Wrap the asdf binary to set ASDF_DIR
    wrapProgram $out/bin/asdf \
      --set ASDF_DIR $out
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Generate completions using the built asdf binary
    installShellCompletion --cmd asdf \
      --bash <($out/bin/asdf completion bash) \
      --fish <($out/bin/asdf completion fish) \
      --zsh <($out/bin/asdf completion zsh)
  '';

  meta = {
    description = "Extendable version manager with support for Ruby, Node.js, Erlang & more";
    homepage = "https://asdf-vm.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      c4605
      vringar
    ];
    mainProgram = "asdf";
    platforms = lib.platforms.unix;
  };
})
