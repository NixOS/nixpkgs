{ stdenv, fetchurl, makeWrapper, callPackage, gnupg, utillinux }:

with stdenv.lib;

let 
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    neededNatives = [] ++ optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "keybase-${version}";
  version = "0.7.8";

  src = [(fetchurl {
    url = "https://github.com/keybase/node-client/archive/v${version}.tar.gz";
    sha256 = "1ak27bd7jwyss85i7plnfr5al33ykfifqknncyx1ir2r2ldagzc7";
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
