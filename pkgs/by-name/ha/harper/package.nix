{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-3W/pFtI8G9GOEXt1nCpoy+vp6+59Ya3oqlx2EttGEIk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xPppf2YRgvGqmFBFLZl8XF5apGUX6kICE0jp2nx++io=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
