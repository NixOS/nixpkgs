{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchPypi,
  nodejs,
  npmHooks,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      mistune = super.mistune.overridePythonAttrs (old: rec {
        version = "2.0.5";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "lektor";
  version = "3.4.0b14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lektor";
    repo = "lektor";
    tag = "v${version}";
    # fix for case-insensitive filesystems
    postFetch = ''
      rm -f $out/tests/demo-project/content/icc-profile-test/{LICENSE,license}.txt
    '';
    hash = "sha256-Wr3MhUGihqlPyUlWM8KT+sb/FtHH/NfRNDT9QCKJj5k=";
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/${npmRoot}";
    hash = "sha256-zcvfVVLhHPas4ulyQ9HDG3f5Bofco1A6pDx9TmREOIk=";
  };

  npmRoot = "frontend";

  nativeBuildInputs = [
    python.pkgs.hatch-vcs
    python.pkgs.hatchling
    nodejs
    npmHooks.npmConfigHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    babel
    click
    flask
    inifile
    jinja2
    markupsafe
    marshmallow
    marshmallow-dataclass
    mistune
    pillow
    pip
    python-slugify
    requests
    watchfiles
    werkzeug
  ];

  nativeCheckInputs = with python.pkgs; [
    pytest-click
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    cp -r lektor/translations "$out/${python.sitePackages}/lektor/"
  '';

  pythonImportsCheck = [
    "lektor"
  ];

  disabledTests = [
    # Tests require network access
    "test_path_installed_plugin_is_none"
    "test_VirtualEnv_run_pip_install"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # This is a bit weird, but for some reason fs watch tests fail with sandbox
    "test_sees_created_file"
    "test_sees_deleted_file"
    "test_sees_modified_file"
    "test_sees_file_moved_in"
    "test_sees_file_moved_out"
    "test_sees_deleted_directory"
    "test_sees_file_in_directory_moved_in"
    "test_sees_directory_moved_out"
  ];

  postCheck = ''
    make test-js
  '';

  meta = {
    description = "Static content management system";
    homepage = "https://www.getlektor.com/";
    changelog = "https://github.com/lektor/lektor/blob/v${version}/CHANGES.md";
    license = lib.licenses.bsd3;
    mainProgram = "lektor";
    maintainers = [ ];
  };
}
