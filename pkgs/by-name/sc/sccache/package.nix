{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  distributed ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.17.0";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nnPhRbhcKjV5ODt782IZgsA7qXSFzeFQ/Xmq4MTK74Y=";
  };

  cargoHash = "sha256-mmpDFXEcMJGRVwNHKdme6uEZ8aJlZtgEsWGIECKCLg4=";

  buildFeatures = lib.optionals distributed [
    "dist-client"
    "dist-server"
  ];

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  # Tests fail because of client server setup which is not possible inside the
  # pure environment, see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = {
    description = "Ccache with Cloud Storage";
    mainProgram = "sccache";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      doronbehar
    ];
    license = lib.licenses.asl20;
  };
})
