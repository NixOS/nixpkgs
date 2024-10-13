{
  lib,
  stdenv,
  fetchFromGitHub,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "shdotenv";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "ko1nksm";
    repo = "shdotenv";
    rev = "v${version}";
    hash = "sha256-3O9TUA3/vuC12OJTxVVoAGmgSRq+1xPG7LxX+aXqVCo=";
  };

  buildInputs = [
    gawk
  ];

  preInstall = ''
    export PREFIX="$out"
    mkdir -p $out/bin
  '';

  meta = {
    description = "Dotenv for shells with support for POSIX-compliant and multiple .env file syntax";
    homepage = "https://github.com/ko1nksm/shdotenv";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [ hadrienmp ];
    mainProgram = "shdotenv";
    platforms = lib.platforms.all;
  };
}
