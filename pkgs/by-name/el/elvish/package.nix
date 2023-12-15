{ lib
, buildGoModule
, fetchFromGitHub
, callPackage
}:

let
  pname = "elvish";
  version = "0.19.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "elves";
    repo = "elvish";
    rev = "v${version}";
    hash = "sha256-eCPJXCgmMvrJ2yVqYgXHXJWb6Ec0sutc91LNs4yRBYk=";
  };

  vendorHash = "sha256-VMI20IP1jVkUK3rJm35szaFDfZGEEingUEL/xfVJ1cc=";

  subPackages = [ "cmd/elvish" ];

  ldflags = [
    "-s"
    "-w"
    "-X src.elv.sh/pkg/buildinfo.Version==${version}"
  ];

  strictDeps = true;

  doCheck = false;

  passthru = {
    shellPath = "/bin/elvish";
    tests = {
      expectVersion = callPackage ./tests/expect-version.nix { };
    };
  };

  meta = {
    homepage = "https://elv.sh/";
    description = "A friendly and expressive command shell";
    longDescription = ''
      Elvish is a friendly interactive shell and an expressive programming
      language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0
      status, it is already suitable for most daily interactive use.
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
