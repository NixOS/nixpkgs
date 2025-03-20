{
  lib,
  rustPlatform,
  fetchFromGitHub,
  shared-mime-info,
  libiconv,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "handlr-regex";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = "handlr-regex";
    rev = "v${version}";
    hash = "sha256-ZQAUqR0u+2kBLGyeT7qTcfwF87LY2qRClZ0T3WH78+w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mTb4K2/JNoo1A7AyYapgOhz4oOgJrWftdyDnWh4Bgto=";

  nativeBuildInputs = [
    installShellFiles
    shared-mime-info
  ];

  buildInputs = [ libiconv ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd handlr \
      --zsh <(COMPLETE=zsh $out/bin/handlr) \
      --bash <(COMPLETE=bash $out/bin/handlr) \
      --fish <(COMPLETE=fish $out/bin/handlr)

    installManPage target/release-tmp/build/handlr-regex-*/out/manual/man1/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fork of handlr with support for regex";
    homepage = "https://github.com/Anomalocaridid/handlr-regex";
    license = licenses.mit;
    maintainers = with maintainers; [ anomalocaris ];
    mainProgram = "handlr";
  };
}
