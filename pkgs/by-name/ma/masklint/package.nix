{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  pname = "masklint";
  inherit version;

  src = fetchFromGitHub {
    owner = "brumhard";
    repo = "masklint";
    rev = "v${version}";
    hash = "sha256-Dku2pDUCblopHtoj6viUqHVpVH5GDApp+QLjor38j7g=";
  };

  cargoHash = "sha256-dbcz66t9fLhFjFkDMQ6VJmKa/lI/x2J7sHbguamA4Pw=";

  meta = {
    description = "Lint your mask targets";
    homepage = "https://github.com/brumhard/masklint";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "masklint";
  };
}
