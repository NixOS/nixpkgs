{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bundlerEnv,
  tree,
}:
let
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "drazisil";
    repo = "ghi";
    tag = version;
    hash = "sha256-3V1lxI4VhP0jC3VSWyNS327gOCKowbbLB6ae1idpFFI=";
  };

  rubyEnv = bundlerEnv {
    name = "ghi";
    gemfile = "${src}/Gemfile";
    lockfile = "${src}/Gemfile.lock";
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ghi";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ rubyEnv.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin

    cp ghi $out/bin
  '';

  meta = {
    description = "GitHub Issues on the command line";
    mainProgram = "ghi";
    homepage = "https://github.com/drazisil/ghi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
