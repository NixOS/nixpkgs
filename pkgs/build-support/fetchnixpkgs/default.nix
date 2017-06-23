{ stdenv, fetchFromGitHub }:

{ owner ? "NixOS"
, repo ? "nixpkgs"
, patches ? []
, ...
} @ args:

let
  src = fetchFromGitHub (stdenv.lib.filterAttrs (n: _: !builtins.elem n ["patches"]) (args // { inherit owner repo; }));

  drv = stdenv.mkDerivation rec {
    inherit (src) name;
    inherit src patches;

    dontSubstitute = true;
    preferLocalBuild = true;
    phases = [ "unpackPhase" "patchPhase" "installPhase" ];

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };

in
  if patches == [] then src else drv
