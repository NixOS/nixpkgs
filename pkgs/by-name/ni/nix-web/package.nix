{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  openssl,
  nixVersions,
  nixPackage ? nixVersions.stable,
}:

let
  cargoFlags = [
    "-p"
    "nix-web"
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "nix-web";
  version = "0.4.2";

  src = fetchFromCodeberg {
    owner = "gorgon";
    repo = "gorgon";
    rev = "nix-web-v${version}";
    hash = "sha256-lAk2VfhclHswsctA0RQgEj5oEX1fowh8TCaKykGEioY=";
  };

  cargoHash = "sha256-PfbDod1vQDnWqbhRgXbOvidxGWIXIe7XIgqiLVbovh0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional (!stdenv.hostPlatform.isDarwin) openssl;

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

  meta = {
    description = "Web interface for the Nix store";
    homepage = "https://codeberg.org/gorgon/gorgon/src/branch/main/nix-web";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ embr ];
    mainProgram = "nix-web";
  };
}
