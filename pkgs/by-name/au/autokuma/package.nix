{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autokuma";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "BigBoot";
    repo = "AutoKuma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o1W0ssR4cjzx9VWg3qS2RhJEe4y4Ez/Y+4yRgXs6q0Y=";
  };

  cargoHash = "sha256-nu37qOv34nZ4pkxX7mu4zoLJFZWw3QCPQDS7SMKhqVw=";

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
