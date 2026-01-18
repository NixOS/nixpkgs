{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "jazzy";
  gemdir = ./.;
  exes = [ "jazzy" ];

  passthru.updateScript = bundlerUpdateScript "jazzy";

  meta = {
    description = "Command-line utility that generates documentation for Swift or Objective-C";
    homepage = "https://github.com/realm/jazzy";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      nicknovitski
    ];
  };
}
