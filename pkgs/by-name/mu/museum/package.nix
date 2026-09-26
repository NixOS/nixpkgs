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
  version = "1.3.63";

  src = fetchFromGitHub {
    owner = "ente";
    repo = "ente";
    sparseCheckout = [ "server" ];
    tag = "photos-v${finalAttrs.version}";
    hash = "sha256-rVcfViGKlEnTmF+PBy0WIBxrmvRKlnEiIWb8wfE4m2Y=";
  };

  vendorHash = "sha256-VN7jsCAupfJCJcOBX0JaNQecDVmQfrtsAGJ3qQxd8Oo=";

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
