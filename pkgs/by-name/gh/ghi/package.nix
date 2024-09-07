{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, bundlerEnv
, tree
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghi";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "drazisil";
    repo = "ghi";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-3V1lxI4VhP0jC3VSWyNS327gOCKowbbLB6ae1idpFFI=";
  };

  env = bundlerEnv {
    name = "ghi";

    gemfile = "${finalAttrs.src}/Gemfile";
    lockfile = "${finalAttrs.src}/Gemfile.lock";
    gemset = ./gemset.nix;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ finalAttrs.env.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin

    cp ghi $out/bin
  '';

  meta = {
    description = "GitHub Issues on the command line";
    mainProgram = "ghi";
    homepage = "https://github.com/drazisil/ghi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient];
  };
})
