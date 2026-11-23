{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libyaml";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "libyaml";
    rev = finalAttrs.version;
    sha256 = "sha256-XhjyTxPoGiPcUdE1xATaLExSGx0/hzqhA7XxPqEIBi4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://pyyaml.org/";
    description = "YAML 1.1 parser and emitter written in C";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
