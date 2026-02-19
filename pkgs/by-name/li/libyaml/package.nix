{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libyaml";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "libyaml";
    rev = finalAttrs.version;
    sha256 = "18zsnsxc53pans4a01cs4401a2cjk3qi098hi440pj4zijifgcsb";
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
