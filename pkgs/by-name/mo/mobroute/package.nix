{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "mobroute";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mobroute";
    rev = "v${version}";
    hash = "sha256-2NDZbv3jDM9INl/ZteSL6ege1vRhaeO5LYGBEMuSrmg=";
  };

  proxyVendor = true;

  vendorHash = "sha256-meOYwLTkBAq7G0r9H5GtaT78Ztlxgo3Sfis/qwdC2dQ=";

  buildPhase = ''
    runHook preBuild
    go build -o $GOPATH/bin/${pname} -tags=sqlite_math_functions -buildvcs=false cli/mobroutecli.go
    runHook postBuild
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    go test -failfast -p 1 -v -tags=sqlite_math_functions -buildvcs=false ./...
  '';

  meta = with lib; {
    description = "General purpose public transportation router";
    homepage = "https://git.sr.ht/~mil/mobroute";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.trungtruong1 ];
    mainProgram = "mobroute";
    platforms = platforms.unix;
  };
}
