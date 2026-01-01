{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "scalingo";
<<<<<<< HEAD
  version = "1.41.1";
=======
  version = "1.40.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-1y5YDTeXsr1DPXVV01W6aLHlgr2O5sEBeZ8YW9O01w4=";
=======
    hash = "sha256-AY2Iy7MwZ0OmNdv9EPgJ79Ug8pDuxlVNtLRhlX+XCC4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    rm $out/bin/dists
    installShellCompletion --cmd scalingo \
     --bash cmd/autocomplete/scripts/scalingo_complete.bash \
     --zsh cmd/autocomplete/scripts/scalingo_complete.zsh
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Command line client for the Scalingo PaaS";
    mainProgram = "scalingo";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ cimm ];
=======
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = with lib.platforms; unix;
  };
}
