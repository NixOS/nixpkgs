{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "dnsviz";
  version = "0.11.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dnsviz";
    repo = "dnsviz";
    tag = "v${version}";
    hash = "sha256-JlPikEvRPFhHcTyRJ2ZgmQOrrc6qzhbAO6+NtiN+Wqo=";
  };

  patches = [
    # override DNSVIZ_INSTALL_PREFIX with $out
    ./fix-path.patch
  ];

  postPatch = ''
    substituteInPlace dnsviz/config.py.in \
      --replace-fail '@out@' $out
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dnspython
    m2crypto
    pygraphviz
  ];

  # Tests require network connection and /etc/resolv.conf
  doCheck = false;

  pythonImportsCheck = [ "dnsviz" ];

  meta = {
    description = "Tool suite for analyzing and visualizing DNS and DNSSEC behavior";
    mainProgram = "dnsviz";
    longDescription = ''
      DNSViz is a tool suite for analysis and visualization of Domain Name System (DNS) behavior,
      including its security extensions (DNSSEC).

      This tool suite powers the Web-based analysis available at https://dnsviz.net/
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jojosch ];
  };
}
