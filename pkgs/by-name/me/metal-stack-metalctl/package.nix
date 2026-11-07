{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, go-licenses
, stdenv
, glibc
}:

buildGoModule rec {
  pname = "metal-stack-metalctl";

  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "metal-stack";
    repo = "metalctl";
    rev = "v${version}";
    hash = "sha256-0Di9k00uziLZEvM3TxXuFPYojJNUye+v0cN3WMw7meM=";
  };

  vendorHash = "sha256-EmJZIMG+5/xV7Zf4qXDpOqkCWmBQjHai/MsAQfmTM4g=";

  ldflags = let
    gitversion = "tags/v0.16.2-0-gf9c3071";  # git describe --long --all
    gitsha = "f9c3071b";                     # git rev-parse --short=8 HEAD
    gittime = "2024-05-17T19:05:41+02:00";   # date --iso-8601=seconds
  in [
    "-X github.com/metal-stack/v.Version=${version}"
    "-X github.com/metal-stack/v.Revision=${gitversion}"
    "-X github.com/metal-stack/v.GitSHA1=${gitsha}"
    "-X github.com/metal-stack/v.BuildDate=${gittime}"
  ];

  # unit tests fail because the build dir is no git repo during build anymore
  # see: https://github.com/metal-stack/metalctl/issues/245. Also, the unit tests
  # are being executed on each release anyway, see for example:
  # https://github.com/metal-stack/metalctl/actions/runs/8999417227 for v0.16.2
  doCheck = false;

  meta = {
    description = "Command-line client for metal-stack.io";
    homepage = "https://github.com/metal-stack/metalctl";
    license = lib.licenses.mit;
    mainProgram = "metalctl";
    maintainers = with lib.maintainers; [ tlinden ];
  };
}
