{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  alp,
}:

buildGoModule rec {
  pname = "alp";
  version = "1.1.17";

  src = fetchFromGitHub {
    owner = "gernotfeichter";
    repo = "alp";
    rev = version;
    hash = "sha256-7lyWu1bVn7UwLb/Em6VBbg3FrMyxGjebxt5gJhm/xpI=";
  };
  vendorHash = "sha256-a2CQZKN/rPWh/Pn9gXfSArTCcGST472tsz1Kqm7M4vM=";

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

    go build -o $GOPATH/bin/${pname} main.go

    runHook postBuild
  '';

  passthru.tests = {
    test-version = runCommand "${pname}-test" { } ''
      ${alp}/bin/alp version > $out
      cat $out | grep '${version}'
    '';
  };

  meta = with lib; {
    description = "A convenient authentication method that lets you use your android device as a key for your Linux machine";
    homepage = "https://github.com/gernotfeichter/alp";
    license = licenses.gpl2Only;
    mainProgram = "alp";
    maintainers = with maintainers; [ gernotfeichter ];
  };
}
