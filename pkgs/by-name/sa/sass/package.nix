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

  meta = {
    description = "Tools and Ruby libraries for the CSS3 extension languages: Sass and SCSS";
    homepage = "https://sass-lang.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      romildo
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
