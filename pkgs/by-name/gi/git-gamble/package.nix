{
  lib,
  rustPlatform,
  fetchFromGitLab,
  gitMinimal,
  installShellFiles,
  makeWrapper,
  nix-update-script,
}:

let
  version = "2.9.0";

  src = fetchFromGitLab {
    owner = "pinage404";
    repo = "git-gamble";
    rev = "version/${version}";
    hash = "sha256-hMP5mBKXcO+Ws04G3OxdYuB5JoaSjlYtlkerRQ6+bXw=";
  };
in
rustPlatform.buildRustPackage {
  pname = "git-gamble";
  inherit version src;

  cargoHash = "sha256-vrzcNdLY2PkyZ1eLwOiONRHVAolbTDxytEgi09WkDZQ=";

  nativeCheckInputs = [ gitMinimal ];
  preCheck = ''
    patchShebangs tests/editor/fake_editor.sh
  '';

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  postInstall = ''
    wrapProgram $out/bin/git-gamble \
      --prefix PATH : "${lib.makeBinPath [ gitMinimal ]}"

    export PATH="$PATH:$out/bin/"

    sh ./script/generate_completion.sh target/release/shell_completions/
    installShellCompletion --cmd git-gamble \
      --bash target/release/shell_completions/git-gamble.bash \
      --fish target/release/shell_completions/git-gamble.fish \
      --zsh target/release/shell_completions/_git-gamble

    sh ./script/usage.sh > git-gamble.1
    installManPage git-gamble.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool that blends TDD (Test Driven Development) + TCR (`test && commit || revert`)";
    homepage = "https://git-gamble.is-cool.dev";
    changelog = "https://gitlab.com/pinage404/git-gamble/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.isc;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "git-gamble";
  };
}
