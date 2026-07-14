{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "majima";
  version = "0.5.1";

  src = fetchFromSourcehut {
    owner = "~wq";
    repo = "majima";
    rev = "630427fcd158ccbaafe8bc3f7368fa8577b03548";
    hash = "sha256-znlJY/U7H+BvBM7n4IqE5x9ek1/QVxYkptsAnODz/Q0=";
  };

  cargoHash = "sha256-I0txA41rmTZ3AHllRVsJzmZXbrm5+GSdd08EatxKCzk=";

  meta = {
    description = "Generate random usernames quickly and in various formats";
    homepage = "https://majima.matte.fyi/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ufUNnxagpM ];
    mainProgram = "majima";
  };
}
