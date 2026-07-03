{
  lib,
  clangStdenv,
  fetchFromGitLab,
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
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Nl7Ugj5VPHwW85GJ44luUc2e95kFCanQhDRopGH9nTU=";
  };

  patches = [
    ./match-wrappers.patch
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
