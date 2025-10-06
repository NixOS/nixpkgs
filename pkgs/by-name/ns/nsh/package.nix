{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nsh";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "nuta";
    repo = "nsh";
    rev = "v${version}";
    sha256 = "1479wv8h5l2b0cwp27vpybq50nyvszhjxmn76n2bz3fchr0lrcbp";
  };

  cargoHash = "sha256-kbHNFVu5OIg/eKefhsYRGvlXFduB0aBVflPV9hkM4Ec=";

  doCheck = false;

  meta = {
    description = "Command-line shell like fish, but POSIX compatible";
    mainProgram = "nsh";
    homepage = "https://github.com/nuta/nsh";
    changelog = "https://github.com/nuta/nsh/raw/v${version}/docs/changelog.md";
    license = [
      lib.licenses.cc0 # or
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [ cafkafk ];
  };

  passthru = {
    shellPath = "/bin/nsh";
  };
}
