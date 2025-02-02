{ lib
, fetchFromGitHub
, python3
, writeText
, writeShellScript
, sqlite
, nixosTests
}:
let
  pypkgs = python3.pkgs;

  dbSql = writeText "create_pykms_db.sql" ''
    CREATE TABLE clients(
      clientMachineId TEXT,
      machineName     TEXT,
      applicationId   TEXT,
      skuId           TEXT,
      licenseStatus   TEXT,
      lastRequestTime INTEGER,
      kmsEpid         TEXT,
      requestCount    INTEGER
    );
  '';

  dbScript = writeShellScript "create_pykms_db.sh" ''
    set -eEuo pipefail

    db=''${1:-/var/lib/pykms/clients.db}

    if [ ! -e $db ] ; then
      ${lib.getBin sqlite}/bin/sqlite3 $db < ${dbSql}
    fi
  '';

in
pypkgs.buildPythonApplication rec {
  pname = "pykms";
  version = "unstable-2021-01-25";

  src = fetchFromGitHub {
    owner = "Py-KMS-Organization";
    repo = "py-kms";
    rev = "1435c86fe4f11aa7fd42d77fa61715ca3015eeab";
    hash = "sha256-9KiMbS0uKTbWSZVIv5ziIeR9c8+EKfKd20yPmjCX7GQ=";
  };

  sourceRoot = "${src.name}/py-kms";

  propagatedBuildInputs = with pypkgs; [ systemd pytz tzlocal dnspython ];

  postPatch = ''
    siteDir=$out/${python3.sitePackages}

    substituteInPlace pykms_DB2Dict.py \
      --replace "'KmsDataBase.xml'" "'$siteDir/KmsDataBase.xml'"
  '';

  format = "other";

  # there are no tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $siteDir

    PYTHONPATH="$PYTHONPATH:$siteDir"

    mv * $siteDir
    for b in Client Server ; do
      makeWrapper ${python3.interpreter} $out/bin/''${b,,} \
        --argv0 pykms-''${b,,} \
        --add-flags $siteDir/pykms_$b.py \
        --set PYTHONPATH $PYTHONPATH
    done

    install -Dm755 ${dbScript} $out/libexec/create_pykms_db.sh

    install -Dm644 ../README.md -t $out/share/doc/pykms

    ${python3.interpreter} -m compileall $siteDir

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) pykms; };

  meta = with lib; {
    description = "Windows KMS (Key Management Service) server written in Python";
    homepage = "https://github.com/Py-KMS-Organization/py-kms";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg zopieux ];
  };
}
