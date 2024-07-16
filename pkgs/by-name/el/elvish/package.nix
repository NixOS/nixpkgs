{ lib
, buildGoModule
, fetchFromGitHub
, callPackage
}:

let
  pname = "elvish";
  version = "0.20.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "elves";
    repo = "elvish";
    rev = "v${version}";
    hash = "sha256-lKrX38gVUhYwwuNF25LcZ+TytP4vx/GO7ay6Au4BBZA=";
  };

  vendorHash = "sha256-sgVGqpncV7Ylok5FRcV01a3MCX6UdZvTt3nfVh5L2so=";

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
    description = "Friendly and expressive command shell";
    mainProgram = "elvish";
    longDescription = ''
      Elvish is a friendly interactive shell and an expressive programming
      language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0
      status, it is already suitable for most daily interactive use.
    '';
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
