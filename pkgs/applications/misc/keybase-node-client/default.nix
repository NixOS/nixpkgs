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
  version = "0.7.7";

  src = [(fetchurl {
    url = "https://github.com/keybase/node-client/archive/v${version}.tar.gz";
    sha256 = "1p2plxz4lf5pbrvl5sql00lk459lnxcz7cxc4cdhfzc6h4ql425f";
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
