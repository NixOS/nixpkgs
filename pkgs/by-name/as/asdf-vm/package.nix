{
<<<<<<< HEAD
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
=======
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  bash,
  curl,
  git,
  writeScript,
}:

let
  asdfReshimFile = writeScript "asdf-reshim" ''
    #!/usr/bin/env bash

    # asdf-vm create "shim" file like this:
    #
    #    exec $ASDF_DIR/bin/asdf exec "node" "$@"
    #
    # So we should reshim all installed versions every time shell initialized,
    # because $out always change

    asdfDir="''${ASDF_DIR:-$HOME/.asdf}"
    asdfDataDir="''${ASDF_DATA_DIR:-$HOME/.asdf}"

    prevAsdfDirFilePath="$asdfDataDir/.nix-prev-asdf-dir-path"

    if [ -r "$prevAsdfDirFilePath" ]; then
      prevAsdfDir="$(cat "$prevAsdfDirFilePath")"
    else
      prevAsdfDir=""
    fi

    if [ "$prevAsdfDir" != "$asdfDir" ]; then
      rm -rf "$asdfDataDir"/shims
      "$asdfDir"/bin/asdf reshim
      echo "$asdfDir" > "$prevAsdfDirFilePath"
    fi
  '';

  asdfPrepareFile = writeScript "asdf-prepare" ''
    ASDF_DIR="@asdfDir@"

    source "$ASDF_DIR/asdf.sh"
    ${asdfReshimFile}
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "asdf-vm";
  version = "0.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "asdf-vm";
    repo = "asdf";
<<<<<<< HEAD

    tag = "v${finalAttrs.version}";
    hash = "sha256-BBd+MiRISjMz2m29nNIakG79Oy1k7bZI/Q24QQNp5CY=";

  };

  vendorHash = "sha256-gzlHXIzDYo4leP+37HgNrz5faIlrCLYA7AVSvZ6Uicc=";

=======
    tag = "v${finalAttrs.version}";
    hash = "sha256-quDgoYi+3hZUEAzXWTHuL5UK1T+4o7+G67w0UzZOjJA=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

<<<<<<< HEAD
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
=======
  buildInputs = [
    bash
    curl
    git
  ];

  installPhase = ''
    mkdir -p $out/share/asdf-vm
    cp -r . $out/share/asdf-vm

    mkdir -p $out/etc/profile.d
    substitute ${asdfPrepareFile} $out/etc/profile.d/asdf-prepare.sh \
      --replace "@asdfDir@" "$out/share/asdf-vm"

    mkdir -p $out/bin
    makeWrapper $out/share/asdf-vm/bin/asdf $out/bin/asdf \
      --set ASDF_DIR $out/share/asdf-vm

    installShellCompletion --cmd asdf \
      --zsh completions/_asdf \
      --fish completions/asdf.fish \
      --bash completions/asdf.bash
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  meta = {
    description = "Extendable version manager with support for Ruby, Node.js, Erlang & more";
    homepage = "https://asdf-vm.com/";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      c4605
      vringar
    ];
=======
    maintainers = with lib.maintainers; [ c4605 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "asdf";
    platforms = lib.platforms.unix;
  };
})
