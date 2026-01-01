{
  lib,
  binutils-unwrapped,
  bundlerApp,
  bundlerUpdateScript,
  makeWrapper,
}:

bundlerApp {
  pname = "one_gadget";
  gemdir = ./.;
  exes = [ "one_gadget" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/one_gadget --prefix PATH : ${
      binutils-unwrapped.override { withAllTargets = true; }
    }/bin
  '';

  passthru.updateScript = bundlerUpdateScript "one_gadget";

<<<<<<< HEAD
  meta = {
    description = "Best tool for finding one gadget RCE in libc.so.6";
    homepage = "https://github.com/david942j/one_gadget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Best tool for finding one gadget RCE in libc.so.6";
    homepage = "https://github.com/david942j/one_gadget";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      artemist
      nicknovitski
    ];
    mainProgram = "one_gadget";
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
