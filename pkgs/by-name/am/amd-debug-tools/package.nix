{
  lib,
  python3Packages,
  fetchgit,
  nix-update-script,

  # nativeBuildInputs
  wrapGAppsNoGuiHook,
  gobject-introspection,

  # runtimeDeps
  acpica-tools,
  ethtool,
  fwupd,
  libdisplay-info,
  power-profiles-daemon,
  util-linux,

  # tests
  runCommand,
  amd-debug-tools,
}:

python3Packages.buildPythonPackage rec {
  pname = "amd-debug-tools";
  version = "0.2.3";
  pyproject = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/${pname}.git";
    tag = version;
    hash = "sha256-yWDpVHruVNUWaCUXkeBkXOeSOiW3D9fiQZ8B3Pkug3I=";
  };

  # Upstream bug: quote reuse inside f-string (only available since python 3.12)
  # TODO: https://github.com/superm1/amd-debug-tools/pull/6
  disabled = python3Packages.pythonOlder "3.12";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning>=2.0,<3"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'

    substituteInPlace src/amd_debug/validator.py \
      --replace-fail '/usr/bin/powerprofilesctl' 'powerprofilesctl}'
  '';

  makeWrapperArgs =
    let
      runtimeDeps = lib.makeBinPath [
        acpica-tools
        ethtool
        fwupd
        libdisplay-info
        power-profiles-daemon
        # TODO: How to handle a program that re-execs itself with 'sudo'
        # sudo
        util-linux
      ];
    in
    [
      "--prefix"
      "PATH"
      ":"
      "${runtimeDeps}"
    ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    cysystemd
    jinja2
    matplotlib
    packaging
    pandas
    pygobject3
    pyudev
    seaborn
    tabulate
  ];

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  buildInputs = [
    fwupd
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  disabledTestPaths = [
    # These make calls to runtime dependencies which are not available in the test environement
    "src/test_bios.py"
    "src/test_pstate.py"
    "src/test_s2idle.py"
    "src/test_sleep_report.py"
    "src/test_kernel.py"
    "src/test_validator.py"
  ];

  disabledTests = [
    # Upstream bug that results in an exception if /sys/firmware/acpi/tables/FACP does not exit
    # TODO: https://github.com/superm1/amd-debug-tools/pull/7
    "check_fadt_file_not_found"
  ];

  passthru.tests = {
    amd-bios-version = runCommand "${pname}-test" { } ''
      # '|| true' to catch an upstream bug that lets successful runs exit with status code 1
      # https://github.com/superm1/amd-debug-tools/issues/4
      ${amd-debug-tools}/bin/amd-bios version > $out || true
      [ "$(cat $out)" = "${version}" ]
    '';

    amd-pstate-version = runCommand "${pname}-test" { } ''
      # '|| true' to catch an upstream bug that lets successful runs exit with status code 1
      # https://github.com/superm1/amd-debug-tools/issues/4
      ${amd-debug-tools}/bin/amd-pstate version > $out || true
      [ "$(cat $out)" = "${version}" ]
    '';

    amd-s2idle-version = runCommand "${pname}-test" { } ''
      # '|| true' to catch an upstream bug that lets successful runs exit with status code 1
      # https://github.com/superm1/amd-debug-tools/issues/4
      ${amd-debug-tools}/bin/amd-s2idle version > $out || true
      [ "$(cat $out)" = "${version}" ]
    '';
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Helpful tools for debugging AMD Zen systems";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/about";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git/tag/?h=${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.tigergorilla2 ];
  };
}
