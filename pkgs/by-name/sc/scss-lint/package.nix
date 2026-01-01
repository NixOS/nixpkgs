{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "scss_lint";
  gemdir = ./.;
  exes = [ "scss-lint" ];

  passthru.updateScript = bundlerUpdateScript "scss-lint";

<<<<<<< HEAD
  meta = {
    description = "Tool to help keep your SCSS files clean and readable";
    homepage = "https://github.com/brigade/scss-lint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lovek323
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool to help keep your SCSS files clean and readable";
    homepage = "https://github.com/brigade/scss-lint";
    license = licenses.mit;
    maintainers = with maintainers; [
      lovek323
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
