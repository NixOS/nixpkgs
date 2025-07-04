{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    rev = version;
    hash = "sha256-EtEmaA0ukLoK0vaX+s3d8xodB3pUwSb1EyeyMBF0+rc=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fK5OLgw5XWqfAZDxIZr26ft7X8KmInSPbYlaXOEyzN0=";

  meta = with lib; {
    description = "Better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
