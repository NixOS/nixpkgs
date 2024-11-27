{
  lib,
  fetchFromGitHub,
  python3,
  cacert,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gallia";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Fraunhofer-AISEC";
    repo = "gallia";
    rev = "refs/tags/v${version}";
    hash = "sha256-izMTTZrp4aizq5jS51BNtq3lv9Kr+xI7scZfYKXA/oY=";
  };

  pythonRelaxDeps = [ "aiofiles" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aiofiles
    aiohttp
    aiosqlite
    argcomplete
    python-can
    exitcode
    construct
    httpx
    more-itertools
    msgspec
    platformdirs
    psutil
    pydantic
    pygit2
    tabulate
    tomli
    zstandard
  ];

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "gallia" ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Extendable Pentesting Framework for the Automotive Domain";
    homepage = "https://github.com/Fraunhofer-AISEC/gallia";
    changelog = "https://github.com/Fraunhofer-AISEC/gallia/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [
      fab
      rumpelsepp
    ];
    platforms = platforms.linux;
  };
}
