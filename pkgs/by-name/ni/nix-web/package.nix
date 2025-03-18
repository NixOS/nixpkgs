{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, pkg-config
, openssl
, nixVersions
, nixPackage ? nixVersions.nix_2_18
, darwin
}:

let
  cargoFlags = [ "-p" "nix-web" ];
in
rustPlatform.buildRustPackage rec {
  pname = "nix-web";
  version = "0.4.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gorgon";
    repo = "gorgon";
    rev = "nix-web-v${version}";
    hash = "sha256-lAk2VfhclHswsctA0RQgEj5oEX1fowh8TCaKykGEioY=";
  };
  cargoHash = "sha256-romL/RALr/pmwUA8/SN4AOwc+Vndspd1Yrqs0AHPYRY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional (!stdenv.isDarwin) openssl
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security SystemConfiguration ]);

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
