{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  alp,
}:

buildGoModule rec {
  pname = "alp";
  version = "1.1.18";

  src = fetchFromGitHub {
    owner = "gernotfeichter";
    repo = "alp";
    tag = version;
    hash = "sha256-tE8qKNXLKvFcnDULVkJJ/EJyEsvATCk/3YFkZCmpHSo=";
  };
  vendorHash = "sha256-AHPVhtm6La7HWuxJfpxTsS5wFTUZUJoVyebLGYhNKTg=";

  sourceRoot = "${src.name}/linux";

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
    test-version = runCommand "${pname}-test" { } ''
      ${alp}/bin/alp version > $out
      cat $out | grep '${version}'
    '';
  };

  meta = with lib; {
    description = "Convenient authentication method that lets you use your android device as a key for your Linux machine";
    homepage = "https://github.com/gernotfeichter/alp";
    license = licenses.gpl2Only;
    mainProgram = "alp";
    maintainers = with maintainers; [ gernotfeichter ];
  };
}
