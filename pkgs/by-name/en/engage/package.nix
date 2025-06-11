{
  lib,
  installShellFiles,
  rustPlatform,
  fetchFromGitLab,
  stdenv,
}:

let
  pname = "engage";
  version = "0.2.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitLab {
    domain = "gitlab.computer.surgery";
    owner = "charles";
    repo = "engage";
    rev = "v${version}";
    hash = "sha256-niXh63xTpXSp9Wqwfi8hUBKJSClOUSvB+TPCTaqHfZk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0r5MIoitmFxUODxzi0FBLsUpdGrG1pY8Lo+gy7HeJU8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
    "installShellCompletion --cmd engage "
    + builtins.concatStringsSep " " (
      builtins.map (shell: "--${shell} <($out/bin/engage completions ${shell})") [
        "bash"
        "fish"
        "zsh"
      ]
    )
  );

  meta = {
    description = "Task runner with DAG-based parallelism";
    mainProgram = "engage";
    homepage = "https://gitlab.computer.surgery/charles/engage";
    changelog = "https://gitlab.computer.surgery/charles/engage/-/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
