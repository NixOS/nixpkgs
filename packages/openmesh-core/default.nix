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
      rev = "f7eaee0cf13824b4fc0f7f4dccdd6d31db5b5728";
      sha256 = "050rp4qyy12m7vqhlf7m08srxcrxc6d67l64clral9fc11rfg064"; # Unfinished commit
    };
    
    #vendorHash = lib.fakeHash;
    vendorHash = "sha256-DlbPQgYo/pjTAbI1Fxi7atPxRUtWu5rF2tRtCP/XYTs=";

    outputs = [ "out" ] ++ bins;

    tags = [ "xnode" "openmesh" ];

    meta = with lib; {
      homepage = "https://openmesh.network/";
      description = "Implementation of an Openmesh Network node";
      license = with licenses; [ asl20 ];
      maintainers = with maintainers; [ harrys522 ];
    };
  }