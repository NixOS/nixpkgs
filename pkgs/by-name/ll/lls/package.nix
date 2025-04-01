{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lls";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    tag = "v${version}";
    hash = "sha256-7biyctXeTTZi8PQqKKYn7Qkuw1CxJ9lT6Wo1+rpnjVs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-v4AW6kL546LNdBh9GEJfC5lKJBvVhfF52MS4bOkUbdU=";

  meta = with lib; {
    description = "Tool to list listening sockets";
    license = licenses.mit;
    maintainers = [
      maintainers.k900
      maintainers.jcaesar
    ];
    platforms = platforms.linux;
    homepage = "https://github.com/jcaesar/lls";
    mainProgram = "lls";
  };
}
