{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "sass";
  gemdir = ./.;
  exes = [
    "sass"
    "sass-convert"
    "scss"
  ];

  passthru.updateScript = bundlerUpdateScript "sass";

<<<<<<< HEAD
  meta = {
    description = "Tools and Ruby libraries for the CSS3 extension languages: Sass and SCSS";
    homepage = "https://sass-lang.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tools and Ruby libraries for the CSS3 extension languages: Sass and SCSS";
    homepage = "https://sass-lang.com";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      romildo
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
