{ lib
, fetchFromGitHub
, pkg-config
, libsodium
, buildGoModule
}:

buildGoModule rec {

  version = "photos-v0.9.27";
  pname = "museum";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    rev = version;
    hash = "sha256-ET2j3zYr+yuA9xaoPAeXAWNPsaYwyyAcaGZxyoElYTA=";
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
    maintainers = with maintainers; [ surfaceflinger pinpox ];
    mainProgram = "museum";
    platforms = platforms.linux;
  };
  vendorHash = "sha256-fyfh63uRyVG35JBlzYv9/5z/6F6hr9+qFn3Avt/sN9Q=";
}


