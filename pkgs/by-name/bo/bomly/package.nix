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
  version = "0.24.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bomly-dev";
    repo = "bomly-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Io2bjFwKghi0Y9Zjq2W3q8pplh9LrKmDH0iK8y3igfM=";
  };

  vendorHash = "sha256-vCYu//mzWyc5DKwnPzDAd1QkwUU4JGFE6yxwCEFZjyo=";

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
