{ lib
, stdenv
, fetchFromGitHub
, glibc
, json_c
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "json-search";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cosmo-ray";
    repo = "json-search";
    rev = version;
    hash = "sha256-bzo1qHYY9mVUFG0s8D68Y/t4UoBDBcKEF1+tCR2zTvY=";
  };

  nativeBuildInputs = [
    glibc
    pkg-config
  ];

  buildInputs = [
    json_c
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 json-search -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Small util to search trough JSON";
    homepage = "https://github.com/cosmo-ray/json-search";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ nicolas-goudry ];
    mainProgram = "json-search";
    platforms = platforms.all;
  };
}
