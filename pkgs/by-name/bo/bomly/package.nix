{
  lib,
  buildGoModule,
  fetchFromGitHub,
  grype,
  makeBinaryWrapper,
  nix-update-script,
  syft,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bomly";
  version = "0.21.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bomly-dev";
    repo = "bomly-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oatmSPREtAL8M7xWMkWkFMn49Ey/5GmJegLdQrRa3T4=";
  };

  vendorHash = "sha256-AFyF31OT3wsd4EM+NlWNTKyLnJXxr+UKtY+k6AL7SrA=";

  # .gitattributes excludes all testdata from the GitHub tarball
  postPatch = ''
    mkdir -p internal/benchmark/testdata
    cp ${./scan_targets.json} internal/benchmark/testdata/scan_targets.json
  '';

  buildInputs = [ makeBinaryWrapper ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # testdata directories are excluded from the GitHub tarball via .gitattributes
  doCheck = false;

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  postFixup = ''
    wrapProgram $out/bin/bomly --prefix PATH : "${
      lib.makeBinPath [
        grype
        syft
      ]
    }"
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for dependency intelligence, SBOMs, vulnerability auditing, and CI policy gates";
    homepage = "https://github.com/bomly-dev/bomly-cli";
    changelog = "https://github.com/bomly-dev/bomly-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bomly";
  };
})
