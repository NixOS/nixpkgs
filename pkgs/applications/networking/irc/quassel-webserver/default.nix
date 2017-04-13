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
  version = "2.2.8";
  src = fetchFromGitHub {
    owner  = "magne4000";
    repo   = "quassel-webserver";
    rev    = "11e3f7b4906b5ec3039f2c7e0f33bbbe406d9aeb";
    sha256 = "0jj0vds63v8c67sil579f0knhhjisnyqjragpj95ai4lfzlmqhk4";
  };
  buildInputs = nodePackages.nativeDeps."quassel-webserver" or [];
  deps = [ nodePackages.by-spec."body-parser"."^1.16.0"
           nodePackages.by-spec."commander"."^2.9.0"
           nodePackages.by-spec."cookie-parser"."~1.4.3"
           nodePackages.by-spec."express"."^4.14.1"
           nodePackages.by-spec."less"."^2.7.2"
           nodePackages.by-spec."less-middleware"."^2.2.0"
           nodePackages.by-spec."libquassel"."~2.1.7"
           nodePackages.by-spec."morgan"."^1.8.0"
           nodePackages.by-spec."net-browserify-alt"."^1.1.0"
           nodePackages.by-spec."pug"."^2.0.0-beta11"
           nodePackages.by-spec."serve-favicon"."~2.3.2"
         ];
  peerDependencies = [];

  meta = {
    description = "A web server/client for Quassel";
    license = licenses.mit;
    homepage = "https://github.com/magne4000/quassel-webserver";
    maintainers = with maintainers; [ uwap ];
    platforms = platforms.unix;
  }; 
}
