{ lib
, installShellFiles
, rustPlatform
, fetchgit
}:

let
  pname = "engage";
  version = "0.1.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  # fetchFromGitLab doesn't work on GitLab's end for unknown reasons
  src = fetchgit {
    url = "https://or.computer.surgery/charles/${pname}";
    rev = "v${version}";
    hash = "sha256-B7pDJDoQiigaxcia0LfG7zHEzYtvhCUNpbmfR2ny4ZE=";
  };

  cargoHash = "sha256-Akk7fh7/eyN8gyuh3y3aeeKD2STtrEx+trOm5ww9lgw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = "installShellCompletion --cmd ${pname} "
    + builtins.concatStringsSep
      " "
      (builtins.map
        (shell: "--${shell} <($out/bin/${pname} self completions ${shell})")
        [
          "bash"
          "fish"
          "zsh"
        ]
      );

  meta = {
    description = "A task runner with DAG-based parallelism";
    homepage = "https://or.computer.surgery/charles/engage";
    changelog = "https://or.computer.surgery/charles/engage/-/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
