{ stdenv, lib, buildGoPackage, fetchFromGitHub }:
{
  aws = import ./aws.nix { inherit stdenv lib buildGoPackage fetchFromGitHub; };
  azurerm = import ./azurerm.nix { inherit stdenv lib buildGoPackage fetchFromGitHub; };
  google = import ./google.nix { inherit stdenv lib buildGoPackage fetchFromGitHub; };
  kubernetes = import ./kubernetes.nix { inherit stdenv lib buildGoPackage fetchFromGitHub; };
}
