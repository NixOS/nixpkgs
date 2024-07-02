{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "mobsql";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "mobsql";
    rev = "v${version}";
    hash = "sha256-OKwl9SudYUGAjR8l3y7BCSmCIuDo7IKosh02TedLvnQ=";
  };

  proxyVendor = true;

  vendorHash = "sha256-4Ajo9+MOHh8sew0380kEl4i29UaF7bMm83WomcExH80=";

  buildPhase = ''
    runHook preBuild
    go build -o $GOPATH/bin/${pname} -tags=sqlite_math_functions cli/mobsqlcli.go
    runHook postBuild
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    go test -v ./...
  '';

  meta = with lib; {
    description = "Load Mobility Databases source GTFS feed archives into a SQLite database";
    homepage = "https://git.sr.ht/~mil/mobsql";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.trungtruong1 ];
    mainProgram = "mobsql";
    platforms = platforms.unix;
  };
}
