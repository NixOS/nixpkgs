{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "jazzy";
  gemdir = ./.;
  exes = [ "jazzy" ];

  passthru.updateScript = bundlerUpdateScript "jazzy";

<<<<<<< HEAD
  meta = {
    description = "Command-line utility that generates documentation for Swift or Objective-C";
    homepage = "https://github.com/realm/jazzy";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Command-line utility that generates documentation for Swift or Objective-C";
    homepage = "https://github.com/realm/jazzy";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [
      peterromfeldhk
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      nicknovitski
    ];
  };
}
