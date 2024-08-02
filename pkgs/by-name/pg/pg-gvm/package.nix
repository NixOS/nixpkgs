{
  cmake,
  fetchFromGitHub,
  glib,
  gvm-libs,
  icu,
  lib,
  libical,
  pcre2,
  pkg-config,
  postgresql,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "pg-gvm";
  version = "22.6.5";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "pg-gvm";
    rev = "refs/tags/v${version}";
    hash = "sha256-19ZmQdLjfwJwOMoO16rKJYKOnRyt7SQOdkYTxt8WQ2A=";
  };

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    cmake \
      -DCMAKE_INSTALL_DEV_PREFIX=$out .

    runHook postConfigure
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    gvm-libs
    icu
    libical
    pcre2
    postgresql
  ];

  meta = {
    description = "Greenbone Library for helper functions in PostgreSQL";
    homepage = "https://github.com/greenbone/pg-gvm";
    changelog = "https://github.com/greenbone/pg-gvm/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "pg-gvm";
    platforms = lib.platforms.all;
  };
}
