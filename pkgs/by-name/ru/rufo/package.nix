{
  bundlerApp,
  bundlerUpdateScript,
  lib,
}:

bundlerApp {
  pname = "rufo";
  gemdir = ./.;
  exes = [ "rufo" ];

  passthru.updateScript = bundlerUpdateScript "rufo";

<<<<<<< HEAD
  meta = {
    description = "Ruby formatter";
    homepage = "https://github.com/ruby-formatter/rufo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andersk ];
=======
  meta = with lib; {
    description = "Ruby formatter";
    homepage = "https://github.com/ruby-formatter/rufo";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rufo";
  };
}
