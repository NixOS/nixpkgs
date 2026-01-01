{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  makeWrapper,
  gnugrep,
  libinput,
}:

<<<<<<< HEAD
bundlerApp rec {
=======
bundlerApp {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = bundlerUpdateScript pname;

  meta = {
    description = "Multitouch gestures with libinput driver on X11, Linux";
    homepage = "https://github.com/iberianpig/fusuma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
    platforms = lib.platforms.linux;
=======
  passthru.updateScript = bundlerUpdateScript "fusuma";

  meta = with lib; {
    description = "Multitouch gestures with libinput driver on X11, Linux";
    homepage = "https://github.com/iberianpig/fusuma";
    license = licenses.mit;
    maintainers = with maintainers; [
      nicknovitski
      Br1ght0ne
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
