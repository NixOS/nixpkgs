{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
  nixVersions,
  nixPackage ? nixVersions.nix_2_18,
  darwin,
  nukeReferences,
}:

let
  cargoFlags = [
    "-p"
    "nix-web"
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "nix-web";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gorgon";
    repo = "gorgon";
    rev = "nix-web-v${version}";
    hash = "sha256-/tjcin3p+nE9Y7bhTCj7D4lpjKEFGM1bRqKE8T6igJE=";

    # Various unit tests contain /nix/store/* paths. This breaks the fetcher in a very funny way:
    #   error: illegal path references in fixed-output derivation '/nix/store/52nmkc6v9qhdyzszlvbncndxyrcdfjn3-source.drv'
    nativeBuildInputs = [ nukeReferences ];
    postFetch = ''
      find $out -name "*.rs" -print0 | xargs -0 nuke-refs
    '';
  };
  cargoHash = "sha256-5pPn6APz0kdxuBdz9pgqvECTk6KhXnW/YTjxKgiuD9Q=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    lib.optional (!stdenv.isDarwin) openssl
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
  checkFlags = [
    # Skip tests that rely on store paths nuked by `nuke-refs`.
    "--skip=test_env_value_to_html_store_path_subpath"
    "--skip=test_env_value_to_html_store_path"
  ];

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
