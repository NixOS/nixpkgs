{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  runCommand,
}:

buildGoModule (finalAttrs: {
  pname = "mgc";
  version = "0.61.2";

  src = fetchFromGitHub {
    owner = "MagaluCloud";
    repo = "magalu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-quDsKFpGbTjtuez4PbdxLtWfBzflxfrfa8gbrxRj9zs=";
  };

  modRoot = "./mgc/cli";

  proxyVendor = true;
  vendorHash = "sha256-4DkEG7hCcSRmKsOrURql9jq8jGxzc/gVGxCyUBsA0F8=";

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
