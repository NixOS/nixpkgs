{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "mgc";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "MagaluCloud";
    repo = "magalu";
    tag = "v${version}";
    hash = "sha256-B01+MOqrqXPvt9Nh28xzt95Tu23aO6cPvm4299HXJmE=";
  };

  modRoot = "./mgc/cli";

  proxyVendor = true;
  vendorHash = "sha256-eretHz+e/WLblCgmbST1YPcajC7/I8m4JPah15Y2CFc=";

  tags = [ "embed" ];
  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.RawVersion=v${version}"
  ];
  subPackages = [ "." ];

  postInstall = ''
    mv $out/bin/cli $out/bin/mgc
  '';

  meta = with lib; {
    description = "Interact with Magalu Cloud (MGC) services through the command line";
    license = licenses.gpl3;
    homepage = "https://github.com/MagaluCloud/mgccli";
    mainProgram = "mgc";
    maintainers = with maintainers; [ fabiob ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
