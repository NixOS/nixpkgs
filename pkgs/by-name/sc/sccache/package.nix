{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  distributed ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "0.13.0";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3NdqnK1/vs2Z3SnLDzJBP69E+okqVZaI6dZHEylgcPU=";
  };

  cargoHash = "sha256-aC1FXjE6aj1YUIyXoTIjFHJfTtK40ZaXOl4uV/IgqMs=";

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
