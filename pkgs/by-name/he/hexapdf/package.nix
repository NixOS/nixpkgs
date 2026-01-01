{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby,
}:

bundlerApp {
  pname = "hexapdf";
  exes = [ "hexapdf" ];

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "hexapdf";

<<<<<<< HEAD
  meta = {
    description = "Versatile PDF creation and manipulation library";
    homepage = "https://hexapdf.gettalong.org/";
    changelog = "https://github.com/gettalong/hexapdf/blob/master/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ bbenno ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Versatile PDF creation and manipulation library";
    homepage = "https://hexapdf.gettalong.org/";
    changelog = "https://github.com/gettalong/hexapdf/blob/master/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ bbenno ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hexapdf";
  };
}
