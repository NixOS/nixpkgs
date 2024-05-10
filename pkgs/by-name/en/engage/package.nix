{ lib
, installShellFiles
, rustPlatform
, fetchFromGitLab
}:

let
  pname = "engage";
  version = "0.2.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitLab {
    domain = "or.computer.surgery";
    owner = "charles";
    repo = pname;
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
    mainProgram = "engage";
    homepage = "https://or.computer.surgery/charles/engage";
    changelog = "https://or.computer.surgery/charles/engage/-/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
