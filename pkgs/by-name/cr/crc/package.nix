{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  openShiftVersion = "4.21.14";
  okdVersion = "4.21.0-okd-scos.8";
  microshiftVersion = "4.21.7";
  writeKey = "$(MODULEPATH)/pkg/crc/segment.WriteKey=cvpHsNcmGCJqVzf6YxrSnVlwFSAZaYtp";
  gitCommit = "6eb443d169c5a6dd461db1181f95506aa429f34b";
  gitHash = "sha256-sVByFqYvPLrpG90GYigLEDemaJVF2fj+tSgERmmRzsM=";
in
buildGoModule (finalAttrs: {
  pname = "crc";
  version = "2.61.0";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "crc";
    tag = "v${finalAttrs.version}";
    hash = gitHash;
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace pkg/crc/oc/oc_linux_test.go \
      --replace-fail "/bin/echo" "${coreutils}/bin/echo"
  '';

  subPackages = [ "cmd/crc" ];

  tags = [ "containers_image_openpgp" ];

  ldflags = [
    "-X github.com/crc-org/crc/v2/pkg/crc/version.crcVersion=${finalAttrs.version}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.ocpVersion=${openShiftVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.okdVersion=${okdVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.microshiftVersion=${microshiftVersion}"
    "-X github.com/crc-org/crc/v2/pkg/crc/version.commitSha=${builtins.substring 0 8 gitCommit}"
    "-X github.com/crc-org/crc/v2/pkg/crc/segment.WriteKey=${writeKey}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Manage a local OpenShift 4.x cluster, Microshift or a Podman VM optimized for testing and development purposes";
    homepage = "https://crc.dev/crc/getting_started/getting_started/introducing/";
    changelog = "https://github.com/crc-org/crc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "crc";
    maintainers = with lib.maintainers; [
      matthewpi
      shikanime
      tricktron
    ];
  };
})
