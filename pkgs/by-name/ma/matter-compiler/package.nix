{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "matter_compiler";
  gemdir = ./.;
  exes = [ "matter_compiler" ];

  passthru.updateScript = bundlerUpdateScript "matter-compiler";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Matter Compiler is a API Blueprint AST Media Types to API Blueprint conversion tool.
      It composes an API blueprint from its serialzed AST media-type.
    '';
    homepage = "https://github.com/apiaryio/matter_compiler/";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      rvlander
      manveru
      nicknovitski
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
