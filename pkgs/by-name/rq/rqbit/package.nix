{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  buildNpmPackage,
  nodejs_20,
  nix-update-script,
}:
let
  pname = "rqbit";

  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-5ErcI3hwC2EgxsjgEVlbHP1MzBf/LndpgTfynQGc29s=";
  };

  rqbit-webui = buildNpmPackage {
    pname = "rqbit-webui";

    nodejs = nodejs_20;

    inherit version src;

    sourceRoot = "${src.name}/crates/librqbit/webui";

    npmDepsHash = "sha256-vib8jpf7Jn1qv0m/dWJ4TbisByczNbtEd8hIM5ll2Q8=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-gYasOjrG0oeT/6Ben57MKAvBtgpoSmZ93RZQqSXAxIc=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  preConfigure = ''
    mkdir -p crates/librqbit/webui/dist
    cp -R ${rqbit-webui}/dist/** crates/librqbit/webui/dist
  '';

  postPatch = ''
    # This script fascilitates the build of the webui,
    #  we've already built that
    rm crates/librqbit/build.rs
  '';

  doCheck = false;

  passthru.webui = rqbit-webui;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "webui"
    ];
  };

  meta = {
    description = "Bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cafkafk
      toasteruwu
    ];
    mainProgram = "rqbit";
  };
}
