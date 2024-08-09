{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "git-graph";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = pname;
    rev = "9bd54eb0aed6f108364bce9ad0bdff12077038fc";
    hash = "sha256-tMM/mpt9yzZYSpnOGBuGLM0XTJiiyChfUrERMuyn3mQ=";
  };

  cargoHash = "sha256-NLFkjn/qCn+FetpbMiLpQhkzDEVIkKuPRhuFuT8AnNY=";

  meta = with lib; {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-graph";
    license = licenses.mit;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "git-graph";
  };
}
