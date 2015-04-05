{ pkgs, buildArgs ? ":common" } :

with pkgs;
with pkgs.lib;

let
  nodePackages = import ../../../../pkgs/top-level/node-packages.nix {
    inherit pkgs;
    inherit (pkgs) stdenv nodejs fetchurl fetchgit;
    neededNatives = [ pkgs.python ] ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
    self = nodePackages;
    generated = ./node-deps.nix;
  };
in
nodePackages.buildNodePackage rec {
  name = "highlight.js-${version}";
  version = "8.5";

  sources = fetchFromGitHub {
    owner = "isagalaev";
    repo = "highlight.js";
    rev = "${version}";
    sha256 = "0495divpk5g3kx5h4glqjlqxvld77aghvsxlj0gkl3a97ix2xmq1";
  };

  src = [ sources ];

  buildPhase = ''
    cp -r ${sources}/* .
    node tools/build.js ${buildArgs}
  '';

  installPhase = ''
    mkdir -p $out
    mv build/highlight.pack.js $out
    cp -r src/styles $out
  '';

  dontStrip = true;

  deps = filter (v: nixType v == "derivation") (attrValues nodePackages);

  passthru.names = [ "highlight.js" ];

  meta = {
    description = "Highlight.js is a syntax highlighter written in JavaScript.";
    homepage = http://highlightjs.org;
    license = licenses.bsd3;
  };
}
