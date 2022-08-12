{ pkgs ? import <nixpkgs> {} }:
let
  python = pkgs.python3;
  python-with-my-packages = python.withPackages (p: with p; [
    xmltodict
    requests
    packaging
  ]);
in
pkgs.mkShell {
  buildInputs = [
    python-with-my-packages
  ];
  shellHook = ''
    PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
  '';
}
