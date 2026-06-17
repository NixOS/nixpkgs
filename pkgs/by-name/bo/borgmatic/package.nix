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
  version = "2.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T0+E6opyfr7zxfP44OlNuhqsdQyi7OdIXiE5r310LaU=";
  };

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs =
    with python3Packages;
    [
      flexmock
      pytestCheckHook
      pytest-cov-stub
      pytest-timeout
    ]
    ++ optional-dependencies.apprise;

  # - test_borgmatic_version_matches_news_version
  #   NEWS file not available on the pypi source
  # - test_log_outputs_includes_error_output_in_exception
  #   TOCTOU race in log_outputs(): process.poll() returns None in
  #   raise_for_process_errors but non-None in the while-loop exit check,
  #   so the error is never raised. Timing-dependent; fails on x86_64-darwin.
  disabledTests = [
    "test_borgmatic_version_matches_news_version"
    "test_log_outputs_includes_error_output_in_exception"
  ];

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
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd borgmatic \
        --bash <($out/bin/borgmatic --bash-completion) \
        --fish <($out/bin/borgmatic --fish-completion)
    ''
    + lib.optionalString enableSystemd ''
      mkdir -p $out/lib/systemd/system
      cp sample/systemd/borgmatic.timer $out/lib/systemd/system/
      # there is another "sleep", so choose the one with the space after it
      # due to https://github.com/borgmatic-collective/borgmatic/commit/2e9f70d49647d47fb4ca05f428c592b0e4319544
      substitute sample/systemd/borgmatic.service \
        $out/lib/systemd/system/borgmatic.service \
        --replace-fail /root/.local/bin/borgmatic $out/bin/borgmatic \
        --replace-fail systemd-inhibit ${systemd}/bin/systemd-inhibit \
        --replace-fail "sleep " "${coreutils}/bin/sleep "
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
