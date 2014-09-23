{ stdenv, fetchurl, makeWrapper, callPackage, gnupg, utillinux }:

with stdenv.lib;

let 
  nodePackages = callPackage (import <nixpkgs/pkgs/top-level/node-packages.nix>) {
    neededNatives = [] ++ optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "keybase-node-client-${version}";
  version = "0.7.0";

  src = [(fetchurl {
    url = "https://github.com/keybase/node-client/archive/v${version}.tar.gz";
    sha256 = "0n73v4f61rq2dvy2yd3s4l8qvvjzp3ncqj70llm4i6cvbp9kym1v";
  })];

  deps = (filter (v: nixType v == "derivation") (attrValues nodePackages));
  buildInputs = [ makeWrapper gnupg ];

  postInstall = ''
    wrapProgram "$out/bin/keybase" --set NODE_PATH "$out/lib/node_modules/keybase/node_modules/"
  '';

  passthru.names = ["keybase"];

  meta = {
    description = "CLI for keybase.io written in/for Node.js";
    license = licenses.mit;
    homepage = https://keybase.io/docs/command_line;
    maintainers = with maintainers; [manveru];
    platforms = with platforms; linux;
  };
}
