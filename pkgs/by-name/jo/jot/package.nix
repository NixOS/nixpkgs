{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jot";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "araekiel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z8szd6ArwbGiHw7SeAah0LrrzUbcQYygX7IcPUYNxvM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-B3CkXoSShZTnT3OlVaqRBbGIaOKiqri6AuYVrUHB6NQ=";

  meta = with lib; {
    description = "Rapid note management for the terminal";
    homepage = "https://github.com/araekiel/jot";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "jt";
  };
}
