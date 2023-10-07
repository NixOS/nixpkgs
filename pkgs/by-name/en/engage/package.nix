{ lib
, installShellFiles
, rustPlatform
, fetchgit
}:

let
  pname = "engage";
  version = "0.2.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  # fetchFromGitLab doesn't work on GitLab's end for unknown reasons
  src = fetchgit {
    url = "https://or.computer.surgery/charles/${pname}";
    rev = "v${version}";
    hash = "sha256-niXh63xTpXSp9Wqwfi8hUBKJSClOUSvB+TPCTaqHfZk=";
  };

  cargoHash = "sha256-CKe0nb5JHi5+1UlVOl01Q3qSXQLlpEBdat/IzRKfaz0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = "installShellCompletion --cmd ${pname} "
    + builtins.concatStringsSep
      " "
      (builtins.map
        (shell: "--${shell} <($out/bin/${pname} completions ${shell})")
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
