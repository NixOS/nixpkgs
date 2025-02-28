{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "httptap";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "monasticacademy";
    repo = "httptap";
    tag = "v${version}";
    hash = "sha256-1BtV5ao5dAKSINdUdJD/wxTMFXXiP8Vy1A7gQfVIsUQ=";
  };

  patches = [
    # this patch updates go.mod to include missing dependencies
    # https://github.com/monasticacademy/httptap/pull/13
    (fetchpatch {
      name = "update-go-mod";
      url = "https://github.com/monasticacademy/httptap/commit/3b520725c784d6435be6a51c58ae847bae729962.patch";
      hash = "sha256-0dPq0Ldu1m8YZKctFtoUcbQdmx6sqjA8EVhTeMwNWx8=";
    })
  ];

  vendorHash = "sha256-+TtHw2KdeNHCgnMnkxJJ9shqsrlbeTzYwbPH0dJmCjM=";

  env.CGO_ENABLED = 0;

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "View HTTP/HTTPS requests made by any Linux program";
    homepage = "https://github.com/monasticacademy/httptap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
    mainProgram = "httptap";
  };
}
