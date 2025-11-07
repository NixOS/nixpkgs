{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cdwe";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "synoet";
    repo = "cdwe";
    rev = version;
    hash = "sha256-6NWhx82BXhWhbI18k5gE3vEkw9v5gstE8ICJhtq68rM=";
  };

  cargoHash = "sha256-pZpG98lwvggBU1TBb2JuSNLev5Jx8n5QjY902dJVn0Y=";

  meta = with lib; {
    description = "Configurable cd wrapper that lets you define your environment per directory";
    homepage = "https://github.com/synoet/cdwe";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "cdwe";
  };
}
