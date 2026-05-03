{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  runCommand,
}:

buildGoModule (finalAttrs: {
  pname = "mgc";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "MagaluCloud";
    repo = "magalu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I1Duv4sMUoXpZbITxFq55dM/lx78gGI+weVv/Hwbw1M=";
  };

  modRoot = "./mgc/cli";

  proxyVendor = true;
  vendorHash = "sha256-eretHz+e/WLblCgmbST1YPcajC7/I8m4JPah15Y2CFc=";

  tags = [ "embed" ];
  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.RawVersion=v${finalAttrs.version}"
  ];
  subPackages = [ "." ];

  postInstall = ''
    mv $out/bin/cli $out/bin/mgc
  '';

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      ${finalAttrs.finalPackage}/bin/mgc --version
      touch $out
    '';
  };
  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = with lib; {
    description = "Interact with Magalu Cloud (MGC) services through the command line";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/MagaluCloud/mgccli";
    mainProgram = "mgc";
    maintainers = with maintainers; [ fabiob ];
  };
})
