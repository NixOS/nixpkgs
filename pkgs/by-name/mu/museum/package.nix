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
  version = "1.3.16";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    sparseCheckout = [ "server" ];
    tag = "photos-v${finalAttrs.version}";
    hash = "sha256-0Ks29rlCAacOolVXcWX3zedrm6U90Dfe3Mr2uZYfUf4=";
  };

  vendorHash = "sha256-r/zAAWyLe6VYztsZuYlwg0jozGf8cScUKIcIdtZ0LvQ=";

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
      nicegamer7
    ];
    mainProgram = "museum";
    platforms = lib.platforms.linux;
  };
})
