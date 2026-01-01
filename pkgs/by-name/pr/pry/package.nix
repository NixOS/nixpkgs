{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "pry";
  gemdir = ./.;
  exes = [ "pry" ];

  passthru.updateScript = bundlerUpdateScript "pry";

<<<<<<< HEAD
  meta = {
    description = "Ruby runtime developer console and IRB alternative";
    homepage = "https://pryrepl.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tckmn ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Ruby runtime developer console and IRB alternative";
    homepage = "https://pryrepl.org";
    license = licenses.mit;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
