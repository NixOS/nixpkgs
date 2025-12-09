{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "drill";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = "drill";
    rev = version;
    sha256 = "sha256-4y5gpkQB0U6Yq92O6DDD5eq/i/36l/VfeyiE//pcZOk=";
  };

  cargoHash = "sha256-wrfQtJHhSG53tV3R4u/Ri4iv1VoAmuT3xleAQEJOIzE=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  meta = with lib; {
    description = "HTTP load testing application inspired by Ansible syntax";
    homepage = "https://github.com/fcsonline/drill";
    license = licenses.gpl3Only;
    mainProgram = "drill";
  };
}
