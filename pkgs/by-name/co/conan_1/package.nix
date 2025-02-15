{ lib
, stdenv
, fetchFromGitHub
, fetchPypi
, git
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # conan v1.xx requires old semver instead of node-semver
      semver = super.semver.overridePythonAttrs (old: rec {
        version = "0.6.1";
        src = fetchPypi {
          pname = "node-semver";
          inherit version;
          hash = "sha256-QBb3wQcbBJPxjbaeoC03Y+mKYzYG18e+yoEeU7WsZrc=";
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "conan";
  version = "1.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "conan";
    rev = "refs/tags/${version}";
    hash = "sha256-5cvzqIhuP0iw991I0xCqhCTtSy1npHbhoCUx++TPO2I=";
  };

  nativeBuildInputs = with python.pkgs; [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = with python.pkgs; [
    bottle
    colorama
    python-dateutil
    deprecation
    distro
    fasteners
    future
    jinja2
    patch-ng
    pluginbase
    pygments
    pyjwt
    pyyaml
    semver
    requests
    six
    tqdm
    urllib3
  ] ++ lib.optionals stdenv.isDarwin [
    idna
    cryptography
    pyopenssl
  ];

  pythonRelaxDeps = [
    "PyYAML"
    "urllib3"
  ];

  nativeCheckInputs = [
    git
  ] ++ (with python.pkgs; [
    mock
    parameterized
    pytest-xdist
    pytestCheckHook
    webtest
  ]);

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "conan"
  ];

  pytestFlagsArray = [
    "-n"
    "$NIX_BUILD_CORES"
  ];

  disabledTests = [
    # Tests require network access
    "TestFTP"
  ] ++ lib.optionals stdenv.isDarwin [
    # Rejects paths containing nix
    "test_conditional_os"
    # Requires Apple Clang
    "test_detect_default_compilers"
    "test_detect_default_in_mac_os_using_gcc_as_default"
    # Incompatible with darwin.xattr and xcbuild from nixpkgs
    "test_dot_files"
    "test_xcrun"
    "test_xcrun_in_required_by_tool_requires"
    "test_xcrun_in_tool_requires"
  ];

  disabledTestPaths = [
    "conans/test/functional/basic_build_test.py"
    "conans/test/functional/build_helpers/autotools_apple_test.py"
    "conans/test/functional/build_helpers/autotools_environment_test.py"
    "conans/test/functional/build_helpers/cmake_configs_test.py"
    "conans/test/functional/build_helpers/cmake_flags_test.py"
    "conans/test/functional/build_helpers/cmake_folders_test.py"
    "conans/test/functional/build_helpers/cmake_install_package_test.py"
    "conans/test/functional/build_helpers/cmake_ios_cross_build_test.py"
    "conans/test/functional/build_helpers/cmake_targets_test.py"
    "conans/test/functional/build_helpers/cmake_test.py"
    "conans/test/functional/build_helpers/pkg_config_test.py"
    "conans/test/functional/build_requires/profile_build_requires_testing_test.py"
    "conans/test/functional/command/build_test.py"
    "conans/test/functional/command/devflow_test.py"
    "conans/test/functional/command/test_command_test.py"
    "conans/test/functional/complete_test.py"
    "conans/test/functional/conanfile/runner_test.py"
    "conans/test/functional/editable/consume_header_only_test.py"
    "conans/test/functional/editable/consume_settings_and_options_test.py"
    "conans/test/functional/environment/apply_environment_test.py"
    "conans/test/functional/environment/build_environment_test.py"
    "conans/test/functional/environment/run_environment_test.py"
    "conans/test/functional/generators/cmake_apple_frameworks_test.py"
    "conans/test/functional/generators/cmake_find_package_multi_test.py"
    "conans/test/functional/generators/cmake_find_package_multi_version_test.py"
    "conans/test/functional/generators/cmake_find_package_test.py"
    "conans/test/functional/generators/cmake_generator_test.py"
    "conans/test/functional/generators/cmake_multi_test.py"
    "conans/test/functional/generators/cmake_paths_test.py"
    "conans/test/functional/generators/cmake_skip_rpath_test.py"
    "conans/test/functional/generators/cmake_test.py"
    "conans/test/functional/generators/components/pkg_config_test.py"
    "conans/test/functional/generators/components/test_components_cmake_generators.py"
    "conans/test/functional/generators/link_order_test.py"
    "conans/test/functional/generators/make_test.py"
    "conans/test/functional/generators/pkg_config_test.py"
    "conans/test/functional/generators/virtualbuildenv_test.py"
    "conans/test/functional/generators/virtualenv_test.py"
    "conans/test/functional/graph/diamond_test.py"
    "conans/test/functional/graph/private_deps_test.py"
    "conans/test/functional/layout/test_editable_cmake.py"
    "conans/test/functional/layout/test_in_subfolder.py"
    "conans/test/functional/layout/test_source_folder.py"
    "conans/test/functional/scm/issues/test_svn_tag.py"
    "conans/test/functional/scm/scm_test.py"
    "conans/test/functional/scm/test_command_export.py"
    "conans/test/functional/scm/test_git_shallow.py"
    "conans/test/functional/scm/tools/test_git.py"
    "conans/test/functional/scm/tools/test_svn.py"
    "conans/test/functional/scm/workflows/test_conanfile_in_repo_root.py"
    "conans/test/functional/scm/workflows/test_conanfile_in_subfolder.py"
    "conans/test/functional/scm/workflows/test_scm_subfolder.py"
    "conans/test/functional/settings/libcxx_setting_test.py"
    "conans/test/functional/shared_chain_test.py"
    "conans/test/functional/toolchains/"
    "conans/test/functional/tools/scm/test_git.py"
    "conans/test/functional/tools/system/package_manager_test.py"
    "conans/test/functional/tools/test_pkg_config.py"
    "conans/test/functional/tools_versions_test.py"
    "conans/test/functional/util/pkg_config_test.py"
    "conans/test/functional/workspace/workspace_test.py"
    "conans/test/integration/build_helpers/cmake_apple_test.py"
    "conans/test/integration/command/upload/upload_test.py"
    "conans/test/integration/command_v2/help_test.py"
    "conans/test/integration/command_v2/user_test.py"
    "conans/test/integration/toolchains/apple/test_xcodetoolchain.py"
    "conans/test/integration/toolchains/test_check_build_profile.py"
    "conans/test/unittests/client/build/autotools_environment_test.py"
    "conans/test/unittests/client/build/cmake_test.py"
    "conans/test/unittests/client/generators/cmake_test.py"
    "conans/test/unittests/client/tools/net_test.py"
    "conans/test/unittests/client/tools/system_pm_test.py"
    "conans/test/unittests/tools/env/test_env_files.py"
    "conans/test/unittests/tools/qbs/test_qbs_profile.py"
    "conans/test/unittests/util/tools_test.py"
  ];

  meta = with lib; {
    description = "Decentralized and portable C/C++ package manager";
    homepage = "https://conan.io";
    changelog = "https://github.com/conan-io/conan/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznetsss ];
  };
}
