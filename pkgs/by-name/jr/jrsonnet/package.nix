{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "jrsonnet";
  version = "0.4.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "CertainLach";
    repo = "jrsonnet";
    sha256 = "sha256-OX+iJJ3vdCsWWr8x31psV9Vne6xWDZnJc83NbJqMK1A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clap-3.0.0-beta.2" = "sha256-BaLzm2JZEicktfsCIXQipHtEKlEv2lBktfvHP58rjeM=";
    };
  };

  nativeBuildInputs = [ installShellFiles ];

  # skip flaky tests
  checkFlags = [
    "--skip=tests::native_ext"
  ];

  postInstall =
    ''
      ln -s $out/bin/jrsonnet $out/bin/jsonnet

    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash zsh fish; do
        installShellCompletion --cmd jrsonnet \
          --$shell <($out/bin/jrsonnet --generate $shell /dev/null)
        installShellCompletion --cmd jsonnet \
          --$shell <($out/bin/jrsonnet --generate $shell /dev/null | sed s/jrsonnet/jsonnet/g)
      done
    '';

  meta = with lib; {
    description = "Purely-functional configuration language that helps you define JSON data";
    homepage = "https://github.com/CertainLach/jrsonnet";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      lach
    ];
  };
}
