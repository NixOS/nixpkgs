{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autokuma";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "BigBoot";
    repo = "AutoKuma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6w0bHw2mHkZZ3ar5jD+g29S5LjGSrEM+dgs1kN7Mpyk=";
  };

  cargoHash = "sha256-KSoo4f9MddGLGD2x9U3zFDHYreaAaNpBks9Udnq4Pa4=";

  patches = [ ./no-doctest.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postInstall = ''
    mv $out/bin/crdgen $out/bin/autokuma-crdgen
  '';

  meta = {
    description = "Utility that automates the creation of Uptime Kuma monitors";
    homepage = "https://github.com/BigBoot/AutoKuma";
    mainProgram = "autokuma";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hougo ];
  };
})
