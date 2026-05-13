{
  lib,
  stdenv,
  asciidoc,
  fetchFromGitHub,
  gitMinimal,
  rustPlatform,
  installShellFiles,
  which,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-absorb";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tummychow";
    repo = "git-absorb";
    tag = finalAttrs.version;
    hash = "sha256-jAR+Vq6SZZXkseOxZVJSjsQOStIip8ThiaLroaJcIfc=";
  };

  nativeBuildInputs = [
    asciidoc
    installShellFiles
    which # used by Documentation/Makefile
  ];

  cargoHash = "sha256-8uCXk5bXn/x4QXbGOROGlWYMSqIv+/7dBGZKbYkLfF4=";

  nativeCheckInputs = [
    gitMinimal
  ];

  postInstall = ''
    cd Documentation/
    make
    installManPage git-absorb.1
    cd -
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-absorb \
      --bash <($out/bin/git-absorb --gen-completions bash) \
      --fish <($out/bin/git-absorb --gen-completions fish) \
      --zsh <($out/bin/git-absorb --gen-completions zsh)
  '';

  meta = {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "git-absorb";
  };
})
