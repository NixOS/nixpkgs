{ lib, stdenv, fetchFromGitHub, nodejs, python3, callPackage, removeReferencesTo
, pkg-config, libsecret, xcbuild, Security, AppKit, fetchNpmDeps, npmHooks }:

let
  pinData = lib.importJSON ./pin.json;

in stdenv.mkDerivation rec {
  pname = "keytar";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "atom";
    repo = "node-keytar";
    rev = "v${version}";
    hash = pinData.srcHash;
  };

  nativeBuildInputs = [
    nodejs python3 pkg-config
    npmHooks.npmConfigHook
  ]
    ++ lib.optional  stdenv.isDarwin xcbuild;

  buildInputs = lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ lib.optionals stdenv.isDarwin [ Security AppKit ];

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = pinData.npmHash;
  };

  doCheck = false;

  installPhase = ''
    runHook preInstall
    shopt -s extglob
    rm -rf node_modules
    mkdir -p $out
    cp -r ./!(build) $out
    install -D -t $out/build/Release build/Release/keytar.node
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $out/build/Release/keytar.node
    runHook postInstall
  '';

  disallowedReferences = [ stdenv.cc.cc ];
}
