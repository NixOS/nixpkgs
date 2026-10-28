{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
}:

stdenv.mkDerivation {
  pname = "bin2c";
  version = "0-unstable-2020-05-30";

  src = fetchFromGitHub {
    owner = "adobe";
    repo = "bin2c";
    rev = "4300880a350679a808dc05bdc2840368f5c24d9a";
    sha256 = "sha256-PLo5kkN2k3KutVGumoXEB2x9MdxDUtpwAQZLwm4dDvw=";
  };

  makeFlags = [ "prefix=$(out)" ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  checkTarget = "test";
  checkInputs = [ util-linux ]; # uuidgen

  meta = {
    description = "Embed binary & text files inside C binaries";
    mainProgram = "bin2c";
    homepage = "https://github.com/adobe/bin2c";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.shadowrz ];
    platforms = lib.platforms.all;
  };
}
