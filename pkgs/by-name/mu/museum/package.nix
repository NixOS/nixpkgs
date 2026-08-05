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
  version = "1.3.59";

  src = fetchFromGitHub {
    owner = "ente";
    repo = "ente";
    sparseCheckout = [ "server" ];
    tag = "photos-v${finalAttrs.version}";
    hash = "sha256-4M43ilrv3zbk64rQpyE+kd7qSiUyotwGnLa8DVyaOpY=";
  };

  vendorHash = "sha256-Nbh9fs+43e1iE1ujr9T5vu7K1QscG+jdq5+iad4HkDc=";

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
    homepage = "https://github.com/ente/ente/tree/main/server";
    changelog = "https://github.com/ente/ente/releases/tag/photos-v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      oddlama
      nicegamer7
    ];
    mainProgram = "museum";
    platforms = lib.platforms.linux;
  };
})
