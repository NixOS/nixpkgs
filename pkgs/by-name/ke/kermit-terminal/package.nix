{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtk3
, pcre
, pkg-config
, vte
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kermit";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "kermit";
    rev = finalAttrs.version;
    hash = "sha256-XPHF33Nu+H8OcQFwsuUOhDBDWKm8sh5B36sfROeSWPg=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk3
    pcre
    vte
  ];

  passthru.tests.test = nixosTests.terminal-emulators.kermit;

  meta = {
    homepage = "https://github.com/orhun/kermit";
    description = "VTE-based, simple and froggy terminal emulator";
    changelog = "https://github.com/orhun/kermit/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "kermit";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
