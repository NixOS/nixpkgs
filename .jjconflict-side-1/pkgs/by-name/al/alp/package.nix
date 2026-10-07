{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  alp,
}:

buildGoModule (finalAttrs: {
  pname = "alp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "gernotfeichter";
    repo = "alp";
    tag = finalAttrs.version;
    hash = "sha256-ITrvSKjRCNwUuFYrK0+D4bmSqEG7/7NPMLMaitxZgKM=";
  };
  vendorHash = "sha256-JTm40N0x5ucLbmS6fEsrGUNJy5rqjPUSOU+CXzAcGEw=";

  sourceRoot = "${finalAttrs.src.name}/linux";

  # Executing Go commands directly in checkPhase and buildPhase below,
  # because the default testsuite runs all go tests, some of which require docker.
  # Docker is too expensive for https://github.com/NixOS/ofborg.
  checkPhase = ''
    runHook preCheck

    go test -run Test_main_init

    runHook postCheck
  '';

  buildPhase = ''
    runHook preBuild

    go build -o $GOPATH/bin/alp main.go

    runHook postBuild
  '';

  passthru.tests = {
    test-version = runCommand "alp-test" { } ''
      ${alp}/bin/alp version > $out
      cat $out | grep '${finalAttrs.version}'
    '';
  };

  meta = {
    description = "Convenient authentication method that lets you use your android device as a key for your Linux machine";
    homepage = "https://github.com/gernotfeichter/alp";
    license = lib.licenses.gpl2Only;
    mainProgram = "alp";
    maintainers = with lib.maintainers; [ gernotfeichter ];
  };
})
