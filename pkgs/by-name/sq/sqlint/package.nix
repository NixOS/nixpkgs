{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "sqlint";
  gemdir = ./.;

  exes = [ "sqlint" ];

  passthru.updateScript = bundlerUpdateScript "sqlint";

<<<<<<< HEAD
  meta = {
    description = "Simple SQL linter";
    homepage = "https://github.com/purcell/sqlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Simple SQL linter";
    homepage = "https://github.com/purcell/sqlint";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      ariutta
      nicknovitski
      purcell
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
