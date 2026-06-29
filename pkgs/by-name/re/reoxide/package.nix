{
  lib,
  python3,
  fetchFromGitea,
  cacert,
  clang,
  meson,
  pkg-config,
  cppzmq,
  libclang,
  libllvm,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "reoxide";
  version = "0.6.1-unstable-2025-08-27";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ReOxide";
    repo = "reoxide";
    rev = "0ba38caa8656aaf109f674c868bff708a7288bb0";
    hash = "sha256-Pnqr4SuupGk0Fa9d5eJ/zWeJiE9gMxBeHvI2cZV60ew=";
    nativeBuildInputs = [
      meson
      cacert
    ];
    postFetch = ''
      pushd "$out"
        for prj in subprojects/*.wrap; do
          meson subprojects download "$(basename "$prj" .wrap)"
          rm -rf subprojects/$(basename "$prj" .wrap)/.git
        done
      popd
    '';
  };

  build-system = [
    clang
    pkg-config
    python3.pkgs.meson
    python3.pkgs.meson-python
    python3.pkgs.ninja
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    cppzmq
    libclang
    libllvm
    platformdirs
    pyyaml
    pyzmq
  ];

  mesonFlags = [
    "-Db_ndebug=true"
    "-Dextract-actions=enabled"
  ];

  postPatch = ''
    # Replace version.py with a version that returns the package version
    cat > scripts/version.py << 'EOF'
    #! ${python3.interpreter}
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == 'get-vcs':
        print('${version}'.split('-')[0])
    else:
        exit(1)
    EOF
  '';

  pythonImportsCheck = [
    "reoxide"
  ];

  meta = {
    description = "Plugin System for the Ghidra Decompiler";
    homepage = "https://codeberg.org/ReOxide/reoxide";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      themadbit
      eljamm
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "reoxide";
    platforms = lib.platforms.linux;
  };
}
