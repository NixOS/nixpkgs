{
  bundlerApp,
  lib,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "riemann-dash";
  gemdir = ./.;
  exes = [ "riemann-dash" ];

  passthru.updateScript = bundlerUpdateScript "riemann-dash";

<<<<<<< HEAD
  meta = {
    description = "Javascript, websockets-powered dashboard for Riemann";
    homepage = "https://github.com/riemann/riemann-dash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Javascript, websockets-powered dashboard for Riemann";
    homepage = "https://github.com/riemann/riemann-dash";
    license = licenses.mit;
    maintainers = with maintainers; [
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
