{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
}:

buildGoModule rec {
  pname = "asdf-vm";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "asdf-vm";
    repo = "asdf";
    tag = "v${version}";
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
    export ASDF_DIR="$out"
    export PATH="''${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
    EOF

        # Wrap the asdf binary to set ASDF_DIR
        wrapProgram $out/bin/asdf \
          --set ASDF_DIR $out

        # Generate and install shell completions
        mkdir -p $out/share/completions

        # Generate completions using the built asdf binary
        $out/bin/asdf completion bash > $out/share/completions/asdf.bash || true
        $out/bin/asdf completion zsh > $out/share/completions/_asdf || true
        $out/bin/asdf completion fish > $out/share/completions/asdf.fish || true

        # Install completions to standard locations
        installShellCompletion --cmd asdf \
          --bash $out/share/completions/asdf.bash \
          --zsh $out/share/completions/_asdf \
          --fish $out/share/completions/asdf.fish
  '';

  meta = with lib; {
    description = "Extendable version manager with support for Ruby, Node.js, Erlang & more";
    homepage = "https://asdf-vm.com/";
    license = licenses.mit;
    maintainers = [ maintainers.c4605 ];
    mainProgram = "asdf";
    platforms = platforms.unix;
  };
}
