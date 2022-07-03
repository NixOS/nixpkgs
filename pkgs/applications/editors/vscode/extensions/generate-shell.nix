{ pkgs ? import ../../../../.. { } }:

pkgs.mkShell { packages = [ pkgs.scala-cli ]; }
