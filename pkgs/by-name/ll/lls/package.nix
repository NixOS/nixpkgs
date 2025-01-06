{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lls";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    rev = "v${version}";
    hash = "sha256-f2f09ptMBZfBY1jjOEc8ElAoEj4LKXXSdXLlYLf8Z3M=";
  };

  cargoHash = "sha256-LS0azaKBFWW86R4XO5BkCHMEG2UwgkVQIwLELxewiu0=";

  meta = {
    description = "Tool to list listening sockets";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.k900
      lib.maintainers.jcaesar
    ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/jcaesar/lls";
    mainProgram = "lls";
  };
}
