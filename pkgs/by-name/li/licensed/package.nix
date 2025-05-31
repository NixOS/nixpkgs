{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:
bundlerApp rec {
  pname = "licensed";
  gemdir = ./.;
  exes = [ "licensed" ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = {
    description = "Ruby gem to cache and verify the licenses of dependencies";
    homepage = "https://github.com/github/licensed";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jcaesar ];
    platforms = lib.platforms.linux;
  };
}
