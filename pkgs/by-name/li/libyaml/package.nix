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
    hash = "sha256-S7PnooyfyAsIiRAlEPGYkgkVACGaBaCItuqOwrq2+qM=";
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
