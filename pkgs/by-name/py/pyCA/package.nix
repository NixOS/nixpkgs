{
  lib,
  python3,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  stdenv,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      # pyCA is incompatible with SQLAlchemy 2.0
      sqlalchemy = super.sqlalchemy_1_4;
    };
  };

  frontend = buildNpmPackage rec {
    pname = "pyca";
    version = "4.5";

    src = fetchFromGitHub {
      owner = "opencast";
      repo = "pyCA";
      rev = "v${version}";
      sha256 = "sha256-cTkWkOmgxJZlddqaSYKva2wih4Mvsdrd7LD4NggxKQk=";
    };

    npmDepsHash = "sha256-0U+semrNWTkNu3uQQkiJKZT1hB0/IfkL84G7/oP8XYY=";

    nativeBuildInputs = [
      jq
      python
    ];

    postPatch = ''
      ${jq}/bin/jq '. += {"version": "${version}"}' < package.json > package.json.tmp
      mv package.json.tmp package.json
    '';

    installPhase = ''
      mkdir -p $out/static
      cp -R pyca/ui/static/* $out/static/
    '';
  };

in
python3.pkgs.buildPythonApplication rec {
  pname = "pyca";
  version = "4.5";

  src = fetchFromGitHub {
    owner = "opencast";
    repo = "pyCA";
    rev = "v${version}";
    sha256 = "sha256-cTkWkOmgxJZlddqaSYKva2wih4Mvsdrd7LD4NggxKQk=";
  };

  propagatedBuildInputs = with python.pkgs; [
    pycurl
    python-dateutil
    configobj
    sqlalchemy
    sdnotify
    psutil
    flask
    prometheus-client
  ];

  postPatch = ''
    sed -i -e 's#static_folder=.*#static_folder="${frontend}/static")#' pyca/ui/__init__.py
  '';

  passthru = {
    inherit frontend;
  };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Fully functional Opencast capture agent written in Python";
    mainProgram = "pyca";
    homepage = "https://github.com/opencast/pyCA";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ pmiddend ];
  };
}
