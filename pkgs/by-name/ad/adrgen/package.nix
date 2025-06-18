{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  testers,
  adrgen,
}:

buildGoModule rec {
  pname = "adrgen";
  version = "0.4.0-beta";

  src = fetchFromGitHub {
    owner = "asiermarques";
    repo = "adrgen";
    rev = "v${version}";
    hash = "sha256-2ZE/orsfwL59Io09c4yfXt2enVmpSM/QHlUMgyd9RYQ=";
  };

  patches = [
    # https://github.com/asiermarques/adrgen/pull/14
    (fetchpatch {
      name = "update-x-sys-for-go-1.18-on-aarch64-darwin.patch";
      url = "https://github.com/asiermarques/adrgen/commit/485dc383106467d1029ee6d92c9bcbc3c2281626.patch";
      hash = "sha256-38ktHrRgW5ysQmafvFthNtkZ6nnM61z4yEA7wUGmWb4=";
    })
  ];

  vendorHash = "sha256-RXwwv3Q/kQ6FondpiUm5XZogAVK2aaVmKu4hfr+AnAM=";

  passthru.tests.version = testers.testVersion {
    package = adrgen;
    command = "adrgen version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/asiermarques/adrgen";
    description = "Command-line tool for generating and managing Architecture Decision Records";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "adrgen";
  };
}
