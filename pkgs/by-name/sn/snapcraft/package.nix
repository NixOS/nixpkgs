{
  fetchFromGitHub,
  git,
  glibc,
  lib,
  makeWrapper,
  nix-update-script,
  python3Packages,
  squashfsTools,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "snapcraft";
  version = "8.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "snapcraft";
    rev = "refs/tags/${version}";
    hash = "sha256-u5LO29LnAJrU8fafa1EA4ii5g8sO8REfuf/7lzI7x5k=";
  };

  patches = [
    # Snapcraft is only officially distributed as a snap, as is LXD. The socket
    # path for LXD must be adjusted so that it's at the correct location for LXD
    # on NixOS. This patch will likely never be accepted upstream.
    ./lxd-socket-path.patch
    # In certain places, Snapcraft expects an /etc/os-release file to determine
    # host info which doesn't exist in our test environment. This is a
    # relatively naive patch which helps the test suite pass - without it *many*
    # of the tests fail. This patch will likely never be accepted upstream.
    ./os-platform.patch
    # Snapcraft will try to inject itself as a snap *from the host system* into
    # the build system. This patch short-circuits that logic and ensures that
    # Snapcraft is installed on the build system from the snap store - because
    # there is no snapd on NixOS hosts that can be used for the injection. This
    # patch will likely never be accepted upstream.
    ./set-channel-for-nix.patch
    # Certain paths (for extensions, schemas) are packaged in the snap by the
    # upstream, so the paths are well-known, except here where Snapcraft is
    # *not* in a snap, so this patch changes those paths to point to the correct
    # place in the Nix store. This patch will likely never be accepted upstream.
    ./snapcraft-data-dirs.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version=determine_version()' 'version="${version}"' \
      --replace-fail 'gnupg' 'python-gnupg'

    substituteInPlace requirements.txt \
      --replace-fail 'gnupg==2.3.1' 'python-gnupg'

    substituteInPlace snapcraft/__init__.py \
      --replace-fail '__version__ = _get_version()' '__version__ = "${version}"'

    substituteInPlace snapcraft_legacy/__init__.py \
      --replace-fail '__version__ = _get_version()' '__version__ = "${version}"'

    substituteInPlace snapcraft/elf/elf_utils.py \
      --replace-fail 'arch_linker_path = Path(arch_config.dynamic_linker)' \
      'return str(Path("${glibc}/lib/ld-linux-x86-64.so.2"))'

    substituteInPlace pyproject.toml \
      --replace-fail '"pytest-cov>=4.0",' ""
  '';

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3Packages; [
    attrs
    catkin-pkg
    click
    craft-application
    craft-archives
    craft-cli
    craft-grammar
    craft-parts
    craft-platforms
    craft-providers
    craft-store
    python-debian
    docutils
    jsonschema
    launchpadlib
    lazr-restfulclient
    lxml
    macaroonbakery
    mypy-extensions
    overrides
    packaging
    progressbar
    pyelftools
    pygit2
    pylxd
    pymacaroons
    python-apt
    python-gnupg
    pyxdg
    pyyaml
    raven
    requests-toolbelt
    requests-unixsocket2
    simplejson
    snap-helpers
    tabulate
    toml
    tinydb
    typing-extensions
    urllib3
    validators
  ];

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [
    "docutils"
    "jsonschema"
    "pygit2"
    "urllib3"
    "validators"
  ];

  postInstall = ''
    wrapProgram $out/bin/snapcraft --prefix PATH : ${squashfsTools}/bin
  '';

  nativeCheckInputs =
    with python3Packages;
    [
      pytest-check
      pytest-cov-stub
      pytest-mock
      pytest-subprocess
      pytestCheckHook
      responses
      setuptools
    ]
    ++ [
      git
      squashfsTools
    ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    "test_bin_echo"
    "test_classic_linter_filter"
    "test_classic_linter"
    "test_complex_snap_yaml"
    "test_core24_try_command"
    "test_get_base_configuration_snap_channel"
    "test_get_base_configuration_snap_instance_name_default"
    "test_get_base_configuration_snap_instance_name_not_running_as_snap"
    "test_get_build_commands"
    "test_get_extensions_data_dir"
    "test_get_os_platform_alternative_formats"
    "test_get_os_platform_linux"
    "test_get_os_platform_windows"
    "test_lifecycle_pack_components_with_output"
    "test_lifecycle_pack_components"
    "test_lifecycle_write_component_metadata"
    "test_parse_info_integrated"
    "test_patch_elf"
    "test_remote_builder_init"
    "test_setup_assets_remote_icon"
    "test_snap_command_fallback"
    "test_validate_architectures_supported"
    "test_validate_architectures_unsupported"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "test_load_project" ];

  disabledTestPaths = [
    "tests/unit/commands/test_remote.py"
    "tests/unit/elf"
    "tests/unit/linters/test_classic_linter.py"
    "tests/unit/linters/test_library_linter.py"
    "tests/unit/parts/test_parts.py"
    "tests/unit/services"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "snapcraft";
    description = "Build and publish Snap packages";
    homepage = "https://github.com/canonical/snapcraft";
    changelog = "https://github.com/canonical/snapcraft/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
