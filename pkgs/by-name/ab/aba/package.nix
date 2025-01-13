{
  fetchFromSourcehut,
  just,
  lib,
  nix-update-script,
  rustPlatform,
  scdoc,
}:
let
  version = "0.8.0";
in
rustPlatform.buildRustPackage {
  pname = "aba";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~onemoresuza";
    repo = "aba";
    rev = version;
    hash = "sha256-2zVQNchL4DFh2v2/kwupJTBSmXiKqlxzUMrP9TbfCMs=";
  };

  cargoHash = "sha256-YhSzbfcEIJjKWlyYq1lK70qt4f/Z71n7hgaaZ/D/U80=";

  nativeBuildInputs = [
    just
    scdoc
  ];

  postPatch = ''
    # Let only nix strip the binary by disabling cargo's `strip = true`, like
    # buildRustPackage does when not using just's setup hooks.
    sed -i '/strip[[:space:]]*=[[:space:]]*true/s/true/false/' ./Cargo.toml
  '';

  preBuild = ''
    justFlagsArray+=(
      PREFIX=${builtins.placeholder "out"}
      MANIFEST_OPTS="--frozen --locked --profile=release"
      INSTALL_OPTS="--no-track"
    )
  '';

  # There are no tests
  doCheck = false;
  dontUseJustCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Address book for aerc";
    homepage = "https://sr.ht/~onemoresuza/aba/";
    changelog = "https://git.sr.ht/~onemoresuza/aba/tree/main/item/CHANGELOG.md";
    downloadPage = "https://git.sr.ht/~onemoresuza/aba/refs/${version}";
    maintainers = with lib.maintainers; [ onemoresuza ];
    license = lib.licenses.isc;
    mainProgram = "aba";
  };
}
