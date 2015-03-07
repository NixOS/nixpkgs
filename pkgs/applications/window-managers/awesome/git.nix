{ stdenv, awesome, fetchFromGitHub, ... }:

let
  version = "3.6-git-g4636b11";  # "git describe: v3.5.2-398-g4636b11"
in
stdenv.lib.overrideDerivation awesome (attrs: {
  name = "awesome-${version}";

  src = fetchFromGitHub {
    owner = "awesomeWM";
    repo = "awesome";
    rev = "4636b111b444c874f1f5f41427f8f5d2a9bae556";
    sha256 = "1rvcm8rsy288z6r2k3myx4p13vxp97fxkf328mylfgk58ynfhm45";
  };

  prePatch = ''printf ${version} > .version_stamp'';
})
