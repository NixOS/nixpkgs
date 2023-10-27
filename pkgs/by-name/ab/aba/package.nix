{ fetchFromSourcehut
, just
, lib
, nix-update-script
, rustPlatform
, scdoc
}:
let
  version = "0.7.0";
in
rustPlatform.buildRustPackage {
  pname = "aba";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~onemoresuza";
    repo = "aba";
    rev = version;
    hash = "sha256-YPE5HYa90BcNy5jdYbzkT81KavJcbSeGrsWRILnIiEE=";
    domain = "sr.ht";
  };

  cargoSha256 = "sha256-wzI+UMcVeFQNFlWDkyxk8tjpU7beNRKoPYbid8b15/Q=";

  nativeBuildInputs = [
    just
    scdoc
  ];

  # There are no tests
  doCheck = false;

  dontUseJustBuild = true;
  dontUseJustCheck = true;
  dontUseJustInstall = true;

  postInstall = ''
    just --set PREFIX $out install-doc
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An address book for aerc";
    homepage = "https://sr.ht/~onemoresuza/aba/";
    changelog = "https://git.sr.ht/~onemoresuza/aba/tree/main/item/CHANGELOG.md";
    downloadPage = "https://git.sr.ht/~onemoresuza/aba/refs/${version}";
    maintainers = with lib.maintainers; [ onemoresuza ];
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    mainProgram = "aba";
  };
}
