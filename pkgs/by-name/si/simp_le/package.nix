{
  lib,
  python3Packages,
  fetchPypi,
  bash,
}:

python3Packages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p6+OF8MuAzcdTV4/CvZpjGaOrg7xcNuEddk7yC2sXIE=";
  };

  postPatch = ''
    # drop upper bound of idna requirement
    sed -ri "s/'(idna)<[^']+'/'\1'/" setup.py
    substituteInPlace simp_le.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  # both setuptools-scm and mock are runtime dependencies
  dependencies = with python3Packages; [
    acme
    cryptography
    setuptools-scm
    josepy
    idna
    mock
    pyopenssl
    pytz
    six
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/simp_le --test
    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/zenhack/simp_le";
    description = "Simple Let's Encrypt client";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      gebner
      makefu
    ];
    platforms = lib.platforms.linux;
  };
}
