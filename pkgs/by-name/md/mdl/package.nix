{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "mdl";
  gemdir = ./.;
  exes = [ "mdl" ];

  passthru.updateScript = bundlerUpdateScript "mdl";

  meta = {
    description = "Tool to check markdown files and flag style issues";
    homepage = "https://github.com/markdownlint/markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gerschtli
      nicknovitski
      totoroot
    ];
    platforms = lib.platforms.all;
  };
}
