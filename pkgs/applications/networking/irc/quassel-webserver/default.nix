{ stdenv, lib, fetchFromGitHub, callPackage, python, utillinux}:

with lib;

let
  nodePackages = callPackage ../../../../top-level/node-packages.nix {
    neededNatives = [ python ];
    self = nodePackages;
    generated = ./quassel-webserver.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "quassel-webserver-${version}";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner  = "magne4000";
    repo   = "quassel-webserver";
    rev    = "dda457f38795d15565557a8629085063fa6a7378";
    sha256 = "0syglfdmjnssxdiak1dw8cns5f736v58zmlsh81dvxww90gx3k7h";
  };
  buildInputs = nodePackages.nativeDeps."quassel-webserver" or [];
  deps = [ nodePackages.by-spec."body-parser"."^1.15.2"
           nodePackages.by-spec."commander"."^2.9.0"
           nodePackages.by-spec."cookie-parser"."~1.4.3"
           nodePackages.by-spec."express"."^4.14.0"
           nodePackages.by-spec."jade"."~1.11.0"
           nodePackages.by-spec."less"."^2.7.1"
           nodePackages.by-spec."less-middleware"."^2.2.0"
           nodePackages.by-spec."libquassel"."~2.0.5"
           nodePackages.by-spec."morgan"."^1.7.0"
           nodePackages.by-spec."net-browserify-alt"."^1.0.0"
           nodePackages.by-spec."serve-favicon"."~2.3.0"
         ];
  peerDependencies = [];

  meta = {
    description = "A web server/client for Quassel";
    license = licenses.mit;
    homepage = https://github.com/magne4000/quassel-webserver;
    maintainers = with maintainers; [ uwap ];
    platforms = platforms.unix;
  }; 
}
