{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
}:

let
  pname = "elvish";
  version = "0.21.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "elves";
    repo = "elvish";
    rev = "v${version}";
    hash = "sha256-+qkr0ziHWs3MVhBoqAxrwwbsQVvmGHRKrlqiujqBKvs=";
  };

  vendorHash = "sha256-UjX1P8v97Mi5cLWv3n7pmxgnw+wCr4aRTHDHHd/9+Lo=";

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
