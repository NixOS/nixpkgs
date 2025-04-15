{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spike-spiffe";
  version = "0.3.24";

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spike";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V5zv9z5RznZNxLxD6R4n5AjlVRTX1THpeAy5hq1O4hY=";
  };

  vendorHash = "sha256-eaWeb6HE/vhsIkldmPlgZ4x6gtoVm5myiTA+NTSWbWI=";

  subPackages = [
    "app/keeper/cmd"
    "app/nexus/cmd"
    "app/spike/cmd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Spike incorrectly names all of their binaries cmd
  # Let's work around this with our own installer
  buildPhase = ''
    runHook preBuild

    ${lib.concatMapStringsSep "\n" (sp: ''
      echo "Building subPackage ./${sp}"
      go build \
        -p "$NIX_BUILD_CORES" \
        -ldflags "${toString finalAttrs.ldflags}" \
        -o "$out/bin/${lib.elemAt (lib.splitString "/" sp) 1}" \
        ./${sp}
    '') finalAttrs.subPackages}

    runHook postBuild
  '';

  doCheck = false; # Doesn't work with our custom buildPhase

  meta = {
    description = ''
      SPIKE is a lightweight secrets store that uses SPIFFE as its identity control plane.
      It protects your secrets and helps your ops, SREs, and sysadmins manage sensitive data securely with minimal overhead
    '';
    homepage = "https://spike.ist";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "spike";
  };
})
