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

  meta = {
    description = "Best tool for finding one gadget RCE in libc.so.6";
    homepage = "https://github.com/david942j/one_gadget";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      artemist
      nicknovitski
    ];
    mainProgram = "one_gadget";
    platforms = lib.platforms.unix;
  };
}
