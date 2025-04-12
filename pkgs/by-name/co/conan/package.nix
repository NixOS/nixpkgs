{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  pkg-config,
  xcbuild,
  python3,
  zlib,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "conan";
  version = "2.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "conan";
    rev = "refs/tags/${version}";
    hash = "sha256-1KKXOvoSAemzafWvBoYFtxqgSObHcXe3GVPgG25VNm0=";
  };

  nativeBuildInputs = with python3.pkgs; [
  ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      bottle
      colorama
      python-dateutil
      distro
      fasteners
      jinja2
      patch-ng
      pluginbase
      pygments
      pyjwt
      pylint # Not in `requirements.txt` but used in hooks, see https://github.com/conan-io/conan/pull/6152
      pyyaml
      requests
      tqdm
      urllib3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      idna
      cryptography
      pyopenssl
    ];

  nativeCheckInputs =
    [
      git
      pkg-config
      zlib
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      xcbuild.xcrun
    ]
    ++ (with python3.pkgs; [
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

  disabledTests =
    [
      # Tests require network access
      "TestFTP"
      # Unstable test
      "test_shared_windows_find_libraries"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    # Requires cmake, meson, autotools, apt-get, etc.
    "test/functional/command/runner_test.py"
    "test/functional/command/test_install_deploy.py"
    "test/functional/layout/test_editable_cmake.py"
    "test/functional/layout/test_editable_cmake_components.py"
    "test/functional/layout/test_in_subfolder.py"
    "test/functional/layout/test_source_folder.py"
    "test/functional/test_local_recipes_index.py"
    "test/functional/test_profile_detect_api.py"
    "test/functional/toolchains/"
    "test/functional/tools/scm/test_git.py"
    "test/functional/tools/system/package_manager_test.py"
    "test/functional/tools_versions_test.py"
    "test/functional/util/test_cmd_args_to_string.py"
    "test/integration/command/user_test.py"
    "test/integration/command_v2/list_test.py"
    "test/performance/test_large_graph.py"
    "test/unittests/tools/env/test_env_files.py"
  ];

  meta = with lib; {
    description = "Decentralized and portable C/C++ package manager";
    mainProgram = "conan";
    homepage = "https://conan.io";
    changelog = "https://github.com/conan-io/conan/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ HaoZeke ];
  };
}
