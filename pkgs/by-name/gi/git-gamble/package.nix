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
  version = "2.11.0";

  src = fetchFromGitLab {
    owner = "pinage404";
    repo = "git-gamble";
    rev = "version/${version}";
    hash = "sha256-b7jGrt8uJ9arH4EEsOOPCIcQmhwrrJb8uXcSsZPFrNQ=";
  };
in
rustPlatform.buildRustPackage {
  pname = "git-gamble";
  inherit version src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-lf66me4ot5lvrz2JTj8MreaHyVwOcFSVfPGX9lBTKug=";

  nativeCheckInputs = [ gitMinimal ];
  preCheck = ''
    patchShebangs tests/editor/fake_editor.sh
  '';
  checkFlags = [
    # this test can be flaky ; help is needed to stabilize it in upstream
    "--skip=git_time_keeper::white_box::lock_file::create_as_many_as_lock_files_when_starting_several_times"
  ];

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
