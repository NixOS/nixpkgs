{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "shellclear";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "rusty-ferris-club";
    repo = "shellclear";
    tag = "v${version}";
    hash = "sha256-/0pqegVxrqqxaQ2JiUfkkFK9hp+Vuq7eTap052HEcJs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Q6F7cqs+d1LqYaZkcpCBTOB9Z0qxuGz9zRDK2Yg10CU=";

  buildAndTestSubdir = "shellclear";

  meta = with lib; {
    description = "Secure shell history commands by finding sensitive data";
    homepage = "https://github.com/rusty-ferris-club/shellclear";
    changelog = "https://github.com/rusty-ferris-club/shellclear/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
