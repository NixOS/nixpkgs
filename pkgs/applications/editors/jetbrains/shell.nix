{ pkgs ? import <nixpkgs> {} }:
let
  python = pkgs.python3;
  packages = python.withPackages (p: with p; [
    xmltodict
    requests
    packaging
  ]);
in
pkgs.mkShell {
  buildInputs = [
    packages
  ];
  shellHook = ''
    PYTHONPATH=${packages}/${packages.sitePackages}
  '';
}
