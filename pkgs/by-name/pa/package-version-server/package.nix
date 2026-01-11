{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "package-version-server";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "package-version-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-/YyJ8+tKrNKVrN+F/oHgtExBBRatIIOvWr9mAyTHA3E=";
  };

  cargoHash = "sha256-/t1GPdb/zXe0pKeG/A4FKjKFFZ0zy2nT2PV8nxenKXc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  doCheck = lib.versionAtLeast version "0.0.8";

  meta = {
    description = "Language server that handles hover information in package.json files";
    homepage = "https://github.com/zed-industries/package-version-server/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixdorn ];
    mainProgram = "package-version-server";
  };
}
