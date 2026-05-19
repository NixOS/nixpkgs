{
  lib,
  python313Packages,
  fetchFromGitHub,
  makeWrapper,
}:
python313Packages.buildPythonApplication (finalAttrs: {
  pname = "endcord";
  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "sparklost";
    repo = "endcord";
    tag = "${finalAttrs.version}";
    sha256 = "sha256-YY9NRK5ZXH5Ry7FCGQ158AySRcPwr+jNh2QrcP1YlV4=";
  };
  propagatedBuildInputs = with python313Packages; [
    filetype
    numpy
    orjson
    protobuf
    pycryptodome
    pysocks
    python-socks
    qrcode
    soundcard
    soundfile
    urllib3
    websocket-client
    emoji
    pynacl
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  pythonRelaxDeps = true;
  pyproject = true;
  build-system = with python313Packages; [
    setuptools
    wheel
    cython
  ];
  postInstall = ''
    install -Dm644 $src/main.py "$out/${python313Packages.python.sitePackages}/main.py"
    cp -r $src/endcord "$out/${python313Packages.python.sitePackages}/endcord"
    makeWrapper ${python313Packages.python.interpreter} $out/bin/endcord \
      --add-flags "$out/${python313Packages.python.sitePackages}/main.py" \
      --prefix PYTHONPATH : "$out/${python313Packages.python.sitePackages}:${python313Packages.makePythonPath finalAttrs.propagatedBuildInputs}"
  '';

  __structuredAttrs = true;

  meta = {
    description = "Feature rich Discord TUI client.";
    homepage = "https://github.com/sparklost/endcord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Simon-Weij ];
    platforms = lib.platforms.linux;
    mainProgram = "endcord";
  };
})
