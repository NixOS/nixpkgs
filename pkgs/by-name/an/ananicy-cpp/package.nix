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
}:

clangStdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-oPinSc00+Z6SxjfTh7DttcXSjsLv1X0NI+O37C8M8GY=";
  };

  patches = [
    # FIXME: remove this when updating to next stable release
    (fetchpatch {
      name = "allow-regex-pattern-matching.patch";
      url = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/commit/6ea2dccceec39b6c4913f617dad81d859aa20f24.patch";
      hash = "sha256-C+7x/VpVwewXEPwibi7GxGfjuhDkhcjTyGbZHlYL2Bs=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    bpftools
  ];

  buildInputs = [
    pcre2
    spdlog
    nlohmann_json
    systemd
    libbpf
    elfutils
    zlib
  ];

  # BPF A call to built-in function '__stack_chk_fail' is not supported.
  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_JSON=ON"
    "-DUSE_EXTERNAL_SPDLOG=ON"
    "-DUSE_EXTERNAL_FMTLIB=ON"
    "-DUSE_BPF_PROC_IMPL=ON"
    "-DBPF_BUILD_LIBBPF=OFF"
    "-DENABLE_SYSTEMD=ON"
    "-DENABLE_REGEX_SUPPORT=ON"
    "-DVERSION=${version}"
  ];

  postInstall = ''
    rm -rf "$out"/include
    rm -rf "$out"/lib/cmake
  '';

  meta = {
    homepage = "https://gitlab.com/ananicy-cpp/ananicy-cpp";
    description = "Rewrite of ananicy in c++ for lower cpu and memory usage";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      artturin
      johnrtitor
    ];
    mainProgram = "ananicy-cpp";
  };
}
