{
  borgbackup,
  borgmatic,
  coreutils,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  fetchPypi,
  nix-update-script,
  installShellFiles,
  lib,
  python3Packages,
  stdenv,
  systemd,
  testers,
  nixosTests,
}:
python3Packages.buildPythonApplication rec {
  pname = "borgmatic";
  version = "1.9.14";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w503lwXlKWlTsguzECUGmsbhvdJzTF4XK+Ib2KuD2DE=";
  };

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs =
    with python3Packages;
    [
      flexmock
      pytestCheckHook
      pytest-cov
    ]
    ++ optional-dependencies.apprise;

  # - test_borgmatic_version_matches_news_version
  # The file NEWS not available on the pypi source, and this test is useless
  disabledTests = [
    "test_borgmatic_version_matches_news_version"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '--cov-fail-under=100' ""
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with python3Packages; [
    borgbackup
    colorama
    jsonschema
    packaging
    requests
    ruamel-yaml
    setuptools
  ];

  optional-dependencies = {
    apprise = [ python3Packages.apprise ];
  };

  postInstall =
    ''
      installShellCompletion --cmd borgmatic \
        --bash <($out/bin/borgmatic --bash-completion)
    ''
    + lib.optionalString enableSystemd ''
      mkdir -p $out/lib/systemd/system
      cp sample/systemd/borgmatic.timer $out/lib/systemd/system/
      # there is another "sleep", so choose the one with the space after it
      # due to https://github.com/borgmatic-collective/borgmatic/commit/2e9f70d49647d47fb4ca05f428c592b0e4319544
      substitute sample/systemd/borgmatic.service \
                 $out/lib/systemd/system/borgmatic.service \
                 --replace /root/.local/bin/borgmatic $out/bin/borgmatic \
                 --replace systemd-inhibit ${systemd}/bin/systemd-inhibit \
                 --replace "sleep " "${coreutils}/bin/sleep "
    '';

  passthru.tests = {
    version = testers.testVersion { package = borgmatic; };
    inherit (nixosTests) borgmatic;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple, configuration-driven backup software for servers and workstations";
    homepage = "https://torsion.org/borgmatic/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "borgmatic";
    maintainers = with lib.maintainers; [
      imlonghao
      x123
    ];
  };
}
