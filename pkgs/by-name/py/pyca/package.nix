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
      # pyca is incompatible with SQLAlchemy 2.0
      # error: self.assertIn('autocommit', db.get_session().__dict__.keys())
      sqlalchemy = super.sqlalchemy_1_4;
    };
  };

  frontend = buildNpmPackage rec {
    pname = "pyca";
    version = "4.5";

    src = fetchFromGitHub {
      owner = "opencast";
      repo = "pyCA";
      tag = "v${version}";
      hash = "sha256-cTkWkOmgxJZlddqaSYKva2wih4Mvsdrd7LD4NggxKQk=";
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
      runHook preInstall

      mkdir -p $out/static
      cp -R pyca/ui/static/* $out/static/

      runHook postInstall
    '';
  };

in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pyca";
  version = "4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opencast";
    repo = "pyCA";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cTkWkOmgxJZlddqaSYKva2wih4Mvsdrd7LD4NggxKQk=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
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
    substituteInPlace pyca/ui/__init__.py \
      --replace-fail \
        'static_folder=' \
        'static_folder="${finalAttrs.passthru.frontend}/static") #'
  '';

  pythonImportsCheck = [ "pyca" ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  disabledTests = [
    # Can't pickle a lambda
    "TestPycaMain"
  ];

  passthru = {
    inherit frontend;
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Fully functional Opencast capture agent written in Python";
    mainProgram = "pyca";
    homepage = "https://github.com/opencast/pyCA";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
})
