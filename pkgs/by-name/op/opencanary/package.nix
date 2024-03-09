{
  lib,
  bash,
  fetchPypi,
  makeWrapper,
  nixosTests,
  python3,
  ...
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opencanary";
  version = "0.9.2";
  format = "setuptools";

  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oWwSIZanbUyqX8MmLMJit073kEzOpt/LommzFn1KInY=";
  };

  patches = [
    ./prepare-paths.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    bcrypt
    cryptography
    fpdf
    hpfeeds
    jinja2
    ntlmlib
    passlib
    pcapy-ng
    pyasn1
    pyopenssl
    pypdf2
    requests
    scapy
    service-identity
    setuptools
    simplejson
    twisted
    zope_interface
  ];

  postPatch = ''
    # Fix shebang and invalid bin dirs
    substituteInPlace bin/opencanaryd \
      --replace "@@BASH@@" "#!${lib.getExe bash}" \
      --replace "@@OUTBIN@@" "$out/bin"
  '';

  postInstall = ''
    # Fixes missing 'pkg_resources' and 'opencanary' modules
    wrapProgram $out/bin/opencanaryd \
      --prefix PATH : ${python3}/bin \
      --suffix PATH : ${lib.makeBinPath propagatedBuildInputs} \
      --set NIX_PYTHONPATH "$PYTHONPATH:$out/${python3.sitePackages}"
  '';

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest
    runHook postCheck
  '';

  passthru.tests = {
    opencanary = nixosTests.opencanary;
  };

  meta = {
    description = "A low interaction honeypot intended to be run on internal networks.";
    homepage = "https://github.com/thinkst/opencanary";
    license = lib.licenses.bsd3;
    mainProgram = "opencanaryd";
  };
}
