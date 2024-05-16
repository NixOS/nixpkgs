{ 
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, buildGoModule ? pkgs.buildGoModule
, fetchFromGithub ? pkgs.fetchFromGitHub
}:

let
  bins = [ 
    "openmesh-core"
  ];

  in buildGoModule rec {
    pname = "openmesh-core";
    version = "0.0.0";

    src = fetchFromGitHub {
      owner = "Openmesh-Network";
      repo = "core";
      rev = "v${version}";
      sha256 = "1v23liwbdljbib4rkvfbd3bj0qf4js5p36krqwwiav11vq0ac9a8"; # Unfinished commit
    };
    
    vendorHash = lib.fakeHash;

    outputs = [ "out" ] ++ bins;

    tags = [ "xnode" "openmesh" ];

    meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Implementation of an Openmesh Network node";
      license = with licenses; [ asl20 ];
      maintainers = with maintainers; [ harrys522 ];
    };
  }