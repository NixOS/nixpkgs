{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:
bundlerApp {
  pname = "licensed";
  gemdir = ./.;
  exes = [ "licensed" ];

  passthru.updateScript = bundlerUpdateScript "licensed";

  meta = with lib; {
    description = "Ruby gem to cache and verify the licenses of dependencies";
    homepage = "https://github.com/github/licensed";
    license = licenses.mit;
    maintainers = [ maintainers.jcaesar ];
    platforms = platforms.linux;
  };
}
