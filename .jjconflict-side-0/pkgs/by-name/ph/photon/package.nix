{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "photon";
  version = "1.3.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "s0md3v";
    repo = "Photon";
    rev = "v${finalAttrs.version}";
    sha256 = "02z1xj72bq35dilr4b6njry4kixz6j2a3ag02nla98q0fvgmgnvy";
  };

  dontBuild = true;
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    requests
    urllib3
    tld
  ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/photon}
    cp -R photon.py core plugins $out/share/photon

    makeWrapper ${python3Packages.python.interpreter} $out/bin/photon \
      --set PYTHONPATH "$PYTHONPATH:$out/share/photon" \
      --add-flags "-O $out/share/photon/photon.py"
  '';

  meta = {
    description = "Lightning fast web crawler which extracts URLs, files, intel & endpoints from a target";
    homepage = "https://github.com/s0md3v/Photon";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    mainProgram = "photon";
  };
})
