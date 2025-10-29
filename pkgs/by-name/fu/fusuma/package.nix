{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  makeWrapper,
  gnugrep,
  libinput,
}:

bundlerApp {
  pname = "fusuma";
  gemdir = ./.;
  exes = [ "fusuma" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/fusuma" \
      --prefix PATH : ${
        lib.makeBinPath [
          gnugrep
          libinput
        ]
      }
  '';

  passthru.updateScript = bundlerUpdateScript "fusuma";

  meta = {
    description = "Multitouch gestures with libinput driver on X11, Linux";
    homepage = "https://github.com/iberianpig/fusuma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
      Br1ght0ne
    ];
    platforms = lib.platforms.linux;
  };
}
