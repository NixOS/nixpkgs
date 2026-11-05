{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  fsrx,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fsrx";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "fsrx";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iiVY1p0Yn9+JHUoUvPVKJmh+6JhSUvbcvWlRYWNRsCU=";
  };

  cargoHash = "sha256-Fr/HIaHmmKW9y+NAsGM+VHcnfoLi6t4GZblmW5OunOY=";

  passthru = {
    tests.version = testers.testVersion {
      package = fsrx;
    };
  };

  meta = {
    description = "Flow state reader in the terminal";
    homepage = "https://github.com/jrnxf/fsrx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "fsrx";
  };
})
