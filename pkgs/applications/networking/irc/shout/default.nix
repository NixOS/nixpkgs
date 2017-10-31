{ stdenv, fetchFromGitHub, callPackage, python, utillinux }:

with stdenv.lib;

let
  nodePackages = callPackage (import ../../../../top-level/node-packages.nix) {
    neededNatives = [ python ] ++ optional (stdenv.isLinux) utillinux;
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "shout-${version}";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "erming";
    repo = "shout";
    rev = "2cee0ea6ef5ee51de0190332f976934b55bbc8e4";
    sha256 = "1kci1qha1csb9sqb4ig487q612hgdn5lycbcpad7m9r6chn835qg";
  };

  buildInputs = nodePackages.nativeDeps."shout" or [];

  deps = [
    nodePackages.by-spec."bcrypt-nodejs"."0.0.3"
    nodePackages.by-spec."cheerio"."^0.17.0"
    nodePackages.by-spec."commander"."^2.3.0"
    nodePackages.by-spec."event-stream"."^3.1.7"
    nodePackages.by-spec."express"."^4.9.5"
    nodePackages.by-spec."lodash"."~2.4.1"
    nodePackages.by-spec."mkdirp"."^0.5.0"
    nodePackages.by-spec."moment"."~2.7.0"
    nodePackages.by-spec."read"."^1.0.5"
    nodePackages.by-spec."request"."^2.51.0"
    nodePackages.by-spec."slate-irc"."~0.7.3"
    nodePackages.by-spec."socket.io"."~1.0.6"
  ];

  peerDependencies = [];

  meta = {
    description = "Web IRC client that you host on your own server";
    license = licenses.mit;
    homepage = http://shout-irc.com/;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
