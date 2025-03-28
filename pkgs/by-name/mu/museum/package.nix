{
  lib,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "museum";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    rev = "photos-v${version}";
    hash = "sha256-niEySdGebd9SRRha2dYLsAary3to/9tgV5KePg2LdyE=";
  };

  vendorHash = "sha256-px4pMqeH73Fe06va4+n6hklIUDMbPmAQNKKRIhwv6ec=";

  sourceRoot = "${src.name}/server";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libsodium
  ];

  # fatal: "Not running tests in non-test environment"
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/museum
    cp -R configurations \
      migrations \
      mail-templates \
      $out/share/museum
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "photos-v(.*)"
    ];
  };

  meta = {
    description = "API server for ente.io";
    homepage = "https://github.com/ente-io/ente/tree/main/server";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      surfaceflinger
      pinpox
    ];
    mainProgram = "museum";
    platforms = lib.platforms.linux;
  };
}
