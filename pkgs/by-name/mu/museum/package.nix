{
  lib,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  buildGoModule,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "museum";
  version = "1.2.28";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    tag = "photos-v${finalAttrs.version}";
    hash = "sha256-t0GYaIce5fmQfwpI1cqZEL3OXPmdIet+i1BegIbpU3s=";
  };

  vendorHash = "sha256-napF55nA/9P8l5lddnEHQMjLXWSyTzgblIQCbSZ20MA=";

  sourceRoot = "${finalAttrs.src.name}/server";

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
      web-templates \
      $out/share/museum
  '';

  passthru = {
    tests.ente = nixosTests.ente;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "photos-v(.*)"
      ];
    };
  };

  meta = {
    description = "API server for ente.io";
    homepage = "https://github.com/ente-io/ente/tree/main/server";
    changelog = "https://github.com/ente-io/ente/releases/tag/photos-v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      oddlama
    ];
    mainProgram = "museum";
    platforms = lib.platforms.linux;
  };
})
