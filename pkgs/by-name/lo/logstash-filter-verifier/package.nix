{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "logstash-filter-verifier";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "magnusbaeck";
    repo = "logstash-filter-verifier";
    tag = finalAttrs.version;
    hash = "sha256-JpZ1b2+NaL3AwHyBFJHzf3EZCXKYBpr3kVTo81g2Fmc=";
  };

  vendorHash = "sha256-GtEdURIV5ui6YtR1Pkx4zT5djJlcvK7tQktFQ4Fn1pI=";

  postPatch = ''
    substituteInPlace logstash-filter-verifier.go \
      --replace-fail 'GitSummary = "(unknown)"' 'GitSummary = "${finalAttrs.version}"'
  '';

  ldflags = [ "-s -w" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Run test cases against your Logstash pipelines";
    homepage = "https://github.com/magnusbaeck/logstash-filter-verifier";
    changelog = "https://github.com/magnusbaeck/logstash-filter-verifier/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "logstash-filter-verifier";
    platforms = lib.platforms.unix;
  };
})
