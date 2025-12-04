{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-petname";
  version = "2.0.2";

  src = fetchCrate {
    inherit version;
    crateName = "petname";
    hash = "sha256-KP+GdGlwLHcKE8nAmFr2wHbt5RD9Ptpiz1X5HgJ6BgU=";
  };

  cargoHash = "sha256-gZxZeirvGHwm8C87HdCBYr30+0bbjwnWxIQzcLgl3iQ=";

  meta = with lib; {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = licenses.asl20;
    maintainers = [ maintainers.progrm_jarvis ];
    mainProgram = "petname";
  };
}
