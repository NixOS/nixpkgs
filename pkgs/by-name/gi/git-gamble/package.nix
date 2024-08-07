{
  lib,
  rustPlatform,
  fetchFromGitLab,
  git,
  installShellFiles,
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

  nativeCheckInputs = [ git ];
  preCheck = ''
    patchShebangs tests/editor/fake_editor.sh
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    export PATH="$PATH:$out/bin/"

    sh ./script/generate_completion.sh target/release/shell_completions/
    installShellCompletion --bash target/release/shell_completions/git-gamble.bash
    installShellCompletion --fish target/release/shell_completions/git-gamble.fish
    installShellCompletion --zsh target/release/shell_completions/_git-gamble

    sh ./script/usage.sh > git-gamble.1
    installManPage git-gamble.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool that blends TDD + TCR to make sure to develop the right thing 😌, baby step by baby step 👶🦶";
    longDescription = "Tool that blends [TDD (Test Driven Development)](https://en.wikipedia.org/wiki/Test-driven_development) + [TCR (`test && commit || revert`)](https://medium.com/@kentbeck_7670/test-commit-revert-870bbd756864) to make sure to **develop** the **right** thing 😌, **baby step by baby step** 👶🦶";
    homepage = "https://git-gamble.is-cool.dev";
    changelog = "https://gitlab.com/pinage404/git-gamble/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.isc;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "git-gamble";
  };
}
