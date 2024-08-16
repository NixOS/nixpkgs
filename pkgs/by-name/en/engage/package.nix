{ lib
, installShellFiles
, rustPlatform
, fetchFromGitLab
, stdenv
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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-niXh63xTpXSp9Wqwfi8hUBKJSClOUSvB+TPCTaqHfZk=";
  };

  cargoHash = "sha256-CKe0nb5JHi5+1UlVOl01Q3qSXQLlpEBdat/IzRKfaz0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
    "installShellCompletion --cmd ${pname} "
    + builtins.concatStringsSep
      " "
      (builtins.map
        (shell: "--${shell} <($out/bin/${pname} completions ${shell})")
        [
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
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
