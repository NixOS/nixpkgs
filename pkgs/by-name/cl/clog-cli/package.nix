{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "clog-cli";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "clog-tool";
    repo = "clog-cli";
    rev = "v${version}";
    sha256 = "1wxglc4n1dar5qphhj5pab7ps34cjr7jy611fwn72lz0f6c7jp3z";
  };

  cargoHash = "sha256-yjBgccrkG2D8ZW3Uju4XUhz9Kar50jkJZ75MWhn9j3U=";

  meta = {
    description = "Generate changelogs from local git metadata";
    homepage = "https://github.com/clog-tool/clog-cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.nthorne ];
    mainProgram = "clog";
    # error: could not compile `rustc-serialize`
    broken = true; # Added 2024-03-16
  };
}
