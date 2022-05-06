{ lib
, fetchFromGitHub
, python3
, makeWrapper
}:
python3.pkgs.buildPythonApplication rec {
  pname = "seafdav";
  version = "9.0.7";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafdav";
    rev = "v${version}-server";
    sha256 = "0jdspxz9cakpx0vipqsqf02llz3w02fjid3kff0kclz9apmyvx55";
  };

  dontBuild = true; # $out will contain Python sources, no build necessary

  doCheck = false; # disabled because it requires a ccnet environment

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    future
    jinja2
    json5
    pysearpc
    python-pam
    pyyaml
    six
    lxml
    seaserv
    seafobj
    sqlalchemy
    gunicorn
  ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    cp ${./seafdav.py} $out/seafdav.py
  '';

  passthru = {
    python = python3;
    pythonPath = python3.pkgs.makePythonPath propagatedBuildInputs;
  };

  meta = with lib; {
    description = "Seafile WebDAV Server";
    homepage = "https://github.com/haiwen/seafdav";
    license = licenses.mit;
    maintainers = with maintainers; [ flyx ];
    platforms = platforms.linux;
  };
}
