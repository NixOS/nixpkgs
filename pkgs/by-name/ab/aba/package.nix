{ fetchFromSourcehut
, just
, lib
, nix-update-script
, rustPlatform
, scdoc
}:
let
  version = "0.7.1";
in
rustPlatform.buildRustPackage {
  pname = "aba";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~onemoresuza";
    repo = "aba";
    rev = version;
    hash = "sha256-Sz9I1Dw7wmoUPpTBNfbYbehfNO8FK6r/ubofx+FGb04=";
    domain = "sr.ht";
  };

  cargoSha256 = "sha256-Ihoh+yp12qN74JHvJbEDoYz+eoMwPOQar+yBEy+bqb0=";

  nativeBuildInputs = [
    just
    scdoc
  ];

  postPatch = ''
    # Suppress messages of command not found. jq is not needed for the build, but just calls it anyway.
    sed -i '/[[:space:]]*|[[:space:]]*jq -r/s/jq -r .*/: \\/' ./justfile
    # Let only nix strip the binary by disabling cargo's `strip = true`, like buildRustPackage does.
    sed -i '/strip[[:space:]]*=[[:space:]]*true/s/true/false/' ./Cargo.toml
  '';

  preBuild = ''
    justFlagsArray+=(
      PREFIX=${builtins.placeholder "out"}
      MANIFEST_OPTS="--frozen --locked --profile=release"
      INSTALL_OPTS=--no-track
    )
  '';

  # There are no tests
  doCheck = false;
  dontUseJustCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An address book for aerc";
    homepage = "https://sr.ht/~onemoresuza/aba/";
    changelog = "https://git.sr.ht/~onemoresuza/aba/tree/main/item/CHANGELOG.md";
    downloadPage = "https://git.sr.ht/~onemoresuza/aba/refs/${version}";
    maintainers = with lib.maintainers; [ onemoresuza ];
    license = lib.licenses.isc;
    mainProgram = "aba";
  };
}
