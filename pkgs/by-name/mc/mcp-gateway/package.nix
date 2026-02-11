{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-gateway";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lasso-security";
    repo = "mcp-gateway";
    tag = "v${version}";
    hash = "sha256-5ShgcMWkV2tRceOK4mru3UX7ykYAdfhcdziYzAYho8A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"License :: OSI Approved :: MIT License",' "" \
      --replace-fail 'version = "1.1.0"' 'version = "${version}"'

    substituteInPlace mcp_gateway/gateway.py \
      --replace-fail ', version="1.0.0"' ""
  '';

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    mcp
    requests
    presidio-analyzer
    presidio-anonymizer
    xetrack
    en_core_web_lg
  ];

  meta = {
    description = "Security-first Model Context Protocol gateway";
    homepage = "https://github.com/lasso-security/mcp-gateway";
    changelog = "https://github.com/lasso-security/mcp-gateway/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brantes ];
    mainProgram = "mcp-gateway";
  };
}
