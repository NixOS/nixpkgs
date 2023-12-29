{ lib
, rustPlatform
, fetchFromGitea
, pkg-config
, openssl
, nix
}:

let
  cargoFlags = [ "-p" "nix-web" ];
in
rustPlatform.buildRustPackage rec {
  pname = "nix-web";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gorgon";
    repo = "gorgon";
    rev = "nix-web-v${version}";
    hash = "sha256-+IDvoMRuMt1nS69yFhPPVs+s6Dj0dgXVdjjd9f3+spk=";
  };
  cargoHash = "sha256-uVBfIw++MRxgVAC+KzGVuMZra8oktUfHcZQk90FF1a8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace nix-web/nix-web.service \
      --replace 'ExecStart=nix-web' "ExecStart=$out/bin/nix-web"
  '';
  postInstall = ''
    install -m 644 -D nix-web/nix-web.service $out/lib/systemd/system/nix-web.service
  '';

  cargoBuildFlags = cargoFlags;
  cargoTestFlags = cargoFlags;

  NIX_WEB_BUILD_NIX_CLI_PATH = "${nix}/bin/nix";

  meta = with lib; {
    description = "Web interface for the Nix store";
    homepage = "https://codeberg.org/gorgon/gorgon/src/branch/main/nix-web";
    license = licenses.eupl12;
    maintainers = with maintainers; [ embr ];
    mainProgram = "nix-web";
  };
}
