{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
  buildNpmPackage,
  nodejs_20,
}:
let
  pname = "rqbit";

  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-Lt3HxK8fB1Xn2422wGkJ90muJjZ7r9ZHngGD/2tkaMM=";
  };

  rqbit-webui = buildNpmPackage {
    pname = "rqbit-webui";

    nodejs = nodejs_20;

    inherit version src;

    sourceRoot = "${src.name}/crates/librqbit/webui";

    npmDepsHash = "sha256-VYPZXZx9rKLKZm5+d2wSVkoPLCQCffaeZVSi7mKRH/M=";

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

  cargoHash = "sha256-esDUzzVm5J8fKftBfk5StJzN1YzLa1p0t7BsoxzrowI=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

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

  meta = with lib; {
    description = "Bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cafkafk
      toasteruwu
    ];
    mainProgram = "rqbit";
  };
}
