{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "hiredis";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
    sha256 = "sha256-gbCLIz6nOpPbu0xbsxUVvr7XmvGdVWZQJWjpE76NIXY=";
  };

  buildInputs = [
    openssl
  ];

  PREFIX = "\${out}";
  USE_SSL = 1;

  meta = with lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
