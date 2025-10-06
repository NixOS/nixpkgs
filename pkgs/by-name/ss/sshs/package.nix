{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  sshs,
}:

rustPlatform.buildRustPackage rec {
  pname = "sshs";
  version = "4.7.2";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = "sshs";
    rev = version;
    hash = "sha256-Xr1S6KSw3a/+TIrw2hUPpUOd22+49YMuGK2TVxfwPHU=";
  };

  cargoHash = "sha256-Py85+zv54KHFXjhiThTPXgJQmCImXN42ePOjazjzxIQ=";

  passthru.tests.version = testers.testVersion { package = sshs; };

  meta = {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ not-my-segfault ];
    mainProgram = "sshs";
  };
}
