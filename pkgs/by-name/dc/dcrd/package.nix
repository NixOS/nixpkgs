{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule (finalAttrs: {
  pname = "dcrd";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-ZMcT7fvSRfVQ3o1MDm1lW5jSxWOqSVPRig6s4w08kvU=";
  };

  vendorHash = "sha256-o+wiq5xILbWbjy3+LsozD/v5NlCdruKt+FasPL+BpN8=";

  subPackages = [
    "."
    "cmd/promptsecret"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export DCRD_APPDATA="$TMPDIR"
  '';

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ juaningan ];
  };
})
