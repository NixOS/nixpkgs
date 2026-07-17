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
  version = "0.18.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bomly-dev";
    repo = "bomly-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U7h9U4wiKohJQUauD8lmTScEWpT0kHZobJnJp8u0VbI=";
  };

  vendorHash = "sha256-rO1hymsyc6Ar7PtNLymP66tKK6X6mwVz4kQt4UzzwDI=";

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
