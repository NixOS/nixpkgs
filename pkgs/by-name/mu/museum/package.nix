{
  lib,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  buildGoModule,
}:

buildGoModule rec {

  version = "0.9.53";
  pname = "museum";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    rev = "photos-v${version}";
    hash = "sha256-aczWqK6Zymvl46fHN6QXT0f5V2lpC+8kpSbEoTiP+7k=";
  };

  sourceRoot = "${src.name}/server";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsodium ];

  # fatal: "Not running tests in non-test environment"
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/museum
    cp -R configurations \
      migrations \
      mail-templates \
      $out/share/museum
  '';

  meta = with lib; {
    description = "API server for ente.io";
    homepage = "https://github.com/ente-io/ente/tree/main/server";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      surfaceflinger
      pinpox
    ];
    mainProgram = "museum";
    platforms = platforms.linux;
  };
  vendorHash = "sha256-Vz9AodHoClSmo51ExdOS4bWH13i1Sug++LQMIsZY2xY=";
}
