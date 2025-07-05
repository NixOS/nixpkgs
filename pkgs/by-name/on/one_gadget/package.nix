{
  lib,
  binutils,
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
    wrapProgram $out/bin/one_gadget --prefix PATH : ${binutils}/bin
  '';

  passthru.updateScript = bundlerUpdateScript "one_gadget";

  meta = with lib; {
    description = "Best tool for finding one gadget RCE in libc.so.6";
    homepage = "https://github.com/david942j/one_gadget";
    license = licenses.mit;
    maintainers = with maintainers; [
      artemist
      nicknovitski
    ];
    mainProgram = "one_gadget";
    platforms = platforms.unix;
  };
}
