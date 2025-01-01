{
  lib,
  fetchgit,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "spl";
  version = "0.4.0";
  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/spl";
    rev = "v${version}";
    hash = "sha256-/WjrQeE3zI71pvCil2yE9ZMaWkmyRG/tNmZ+XFF0nYw=";
  };

  cargoHash = "sha256-8xv7tXVklJDewnHqoRIMefsNWTD28+5WyV5ZI9imOh0=";

  meta = {
    description = "Simple, concise, concatenative scripting language";
    homepage = "https://git.tudbut.de/tudbut/spl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "spl";
  };
}
