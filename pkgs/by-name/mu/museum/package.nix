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
  version = "0.9.81";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    rev = "photos-v${version}";
    hash = "sha256-4vX3UWbYYCjNxtSNUAE9hg9NokeJFPTjLvHYTkQlB0w=";
  };

  vendorHash = "sha256-Vz9AodHoClSmo51ExdOS4bWH13i1Sug++LQMIsZY2xY=";

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
