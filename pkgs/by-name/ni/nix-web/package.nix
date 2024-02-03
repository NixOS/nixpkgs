{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, pkg-config
, openssl
, nixVersions
, nixPackage ? nixVersions.nix_2_17
, darwin
}:

let
  cargoFlags = [ "-p" "nix-web" ];
in
rustPlatform.buildRustPackage rec {
  pname = "nix-web";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gorgon";
    repo = "gorgon";
    rev = "nix-web-v${version}";
    hash = "sha256-M/0nlD2jUtvdWJ647QHrp8JcUUVYxiLJlGjnZ+cfpYU=";
  };
  cargoHash = "sha256-6kcpP/CFiy571B98Y96/cdcClH50gdyPLZ28Npva7B4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional (!stdenv.isDarwin) openssl
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  postPatch = ''
    substituteInPlace nix-web/nix-web.service \
      --replace 'ExecStart=nix-web' "ExecStart=$out/bin/nix-web"
  '';
  postInstall = ''
    install -m 644 -D nix-web/nix-web.service $out/lib/systemd/system/nix-web.service
  '';

  cargoBuildFlags = cargoFlags;
  cargoTestFlags = cargoFlags;

  NIX_WEB_BUILD_NIX_CLI_PATH = "${nixPackage}/bin/nix";

  meta = with lib; {
    description = "Web interface for the Nix store";
    homepage = "https://codeberg.org/gorgon/gorgon/src/branch/main/nix-web";
    license = licenses.eupl12;
    platforms = platforms.unix;
    maintainers = with maintainers; [ embr ];
    mainProgram = "nix-web";
  };
}
