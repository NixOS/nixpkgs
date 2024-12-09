{
  lib,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  buildGoModule,
}:

buildGoModule rec {
  pname = "museum";
  version = "0.9.53";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    rev = "photos-v${version}";
    hash = "sha256-aczWqK6Zymvl46fHN6QXT0f5V2lpC+8kpSbEoTiP+7k=";
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
