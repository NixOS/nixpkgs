{
  lib,
  rustPlatform,
  fetchCrate,
  fetchpatch,
}:

rustPlatform.buildRustPackage rec {
  pname = "jen";
  version = "1.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-nouAHEo5JJtZ0pV8ig/iJ3eB8uPz3yMVIYP6RrNVlSA=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "fix-rust-1.80-build.patch";
      url = "https://github.com/whitfin/jen/commit/a6b5239593cecfd803a111ff317afa88c94c3640.patch";
      hash = "sha256-ikfmEj6Xm0nT9dxpx6xdm/mQbw0b3gh2PT6Zo69Zg0E=";
    })
  ];

  cargoHash = "sha256-qYEnKFC1Y24TEY0dXa9N7QNvxhHULq+vd4Wej/RK8HQ=";

  meta = with lib; {
    description = "Simple CLI generation tool for creating large datasets";
    mainProgram = "jen";
    homepage = "https://github.com/whitfin/jen";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
