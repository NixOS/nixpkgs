{ fetchFromGitHub, pkgs, writeShellScriptBin, nodejs, stdenv, lib }:

let
  pname = "saladbind";
  version = "1.7.4";
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  src = fetchFromGitHub {
    owner = "LITDevs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:14l1p7lsgmqwvj37h6d1qynxc9vva2fq7giv527bvz1l60z8gzg4";
  };

  srcAndDependencies = nodePackages.package.override rec {
    inherit src;
  };

  meta = with lib; {
    name = pname;
    version = version;
    description = "SaladBind is a third party integration for Salad";
    homepage = "https://github.com/litdevs/saladbind";
  };

in writeShellScriptBin "saladbind" ''
  pushd ${srcAndDependencies}/lib/node_modules/
  ${nodejs}/bin/node ${srcAndDependencies}/lib/node_modules/saladbind/src/index.js # TODO: implement an actual workaround
''
