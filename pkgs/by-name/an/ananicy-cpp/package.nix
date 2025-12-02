{
  lib,
  clangStdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  pkg-config,
  spdlog,
  nlohmann_json,
  systemd,
  libbpf,
  elfutils,
  bpftools,
  pcre2,
  zlib,
  withBpf ? true,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "ananicy-cpp";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-oPinSc00+Z6SxjfTh7DttcXSjsLv1X0NI+O37C8M8GY=";
  };

  patches = [
    ./match-wrappers.patch

    # FIXME: remove these when updating to next stable release
    (fetchpatch {
      name = "allow-regex-pattern-matching.patch";
      url = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/commit/6ea2dccceec39b6c4913f617dad81d859aa20f24.patch";
      hash = "sha256-C+7x/VpVwewXEPwibi7GxGfjuhDkhcjTyGbZHlYL2Bs=";
    })
    (fetchpatch {
      name = "use-a-reliable-path-for-mounts-file.patch";
      url = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/commit/de6f11978db98bfd13a1e87dcdab61dbe6496710.patch";
      hash = "sha256-9bJlFCClddlAEknfqp7Gcij7NX6tqohE2wqoalLoN5I=";
    })
    # https://gitlab.com/ananicy-cpp/ananicy-cpp/-/merge_requests/30
    (fetchpatch {
      name = "fix-build-with-clang-19.patch";
      url = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/commit/b2589a9b1faa2ecf54aeede40ea781c33bfb09a8.patch";
      hash = "sha256-nfyCdhvnWj446z5aPFCXGi79Xgja8W0Eopl6I30fOBM=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withBpf [
    bpftools
  ];

  buildInputs = [
    pcre2
    spdlog
    nlohmann_json
    systemd
    zlib
  ]
  ++ lib.optionals withBpf [
    libbpf
    elfutils
  ];

  # BPF A call to built-in function '__stack_chk_fail' is not supported.
  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  cmakeFlags = [
    (lib.mapAttrsToList lib.cmakeBool {
      "USE_EXTERNAL_JSON" = true;
      "USE_EXTERNAL_SPDLOG" = true;
      "USE_EXTERNAL_FMTLIB" = true;
      "USE_BPF_PROC_IMPL" = withBpf;
      "BPF_BUILD_LIBBPF" = false;
      "ENABLE_SYSTEMD" = true;
      "ENABLE_REGEX_SUPPORT" = true;
    })
    (lib.cmakeFeature "VERSION" finalAttrs.version)
  ];

  postInstall = ''
    rm -rf "$out"/include
    rm -rf "$out"/lib/cmake
  '';

  meta = {
    homepage = "https://gitlab.com/ananicy-cpp/ananicy-cpp";
    description = "Rewrite of ananicy in c++ for lower cpu and memory usage";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      artturin
      johnrtitor
      diniamo
    ];
    mainProgram = "ananicy-cpp";
  };
})
