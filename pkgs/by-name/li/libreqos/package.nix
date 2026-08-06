{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  # bpf
  llvmPackages,
  bpftools,
  libbpf,
  elfutils,
  zlib,
  openssl,
  pkg-config,
  writeTextFile,
  # web
  esbuild,
  # runtime dependencies
  coreutils,
  ethtool,
  graphviz,
  iproute2,
  procps,
  systemd,
  # python
  python3,
  makeBinaryWrapper,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      apscheduler
      chardet
      deepdiff
      flask
      flask-httpauth
      flask-restful
      graphviz
      psutil
      requests
      routeros-api
      schedule
      setuptools
      waitress
    ]
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libreqos";
  version = "2.2";

  __structuredAttrs = true;

  sourceRoot = "source/src/rust";
  src = fetchFromGitHub {
    owner = "LibreQoE";
    repo = "LibreQoS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMB7b2TXvZ2+3JfNeP4es2/PyFIbomIds0xyLvyInTc=";
  };

  cargoHash = "sha256-O4Bq7Ziws+Oxt0Uf4T8SmYU93ZKEMN16MiamEhcBq3M=";

  patches = [
    # Kernel rejects CPUMAP maps larger than its compile time NR_CPUS (-E2BIG)
    (fetchpatch {
      stripLen = 2;
      url = "https://github.com/LibreQoE/LibreQoS/commit/96a83e223af2816c6774e3f33ab5b45248824bce.patch";
      hash = "sha256-aYtNRleFkHhhp0b3XkAn9VibHfdx2B8VBp/+oJ6+Ldg=";
    })
  ];

  cargoBuildFlags = [
    "--workspace"
    "--exclude"
    "lqos_rs"
  ];

  # https://github.com/search?q=repo%3ALibreQoE%2FLibreQoS+%2FCommand%3A%3Anew(.*)%2F&type=code
  postPatch = ''
    echo 'fn main() { println!("cargo:rustc-env=GIT_HASH=${finalAttrs.src.tag}"); }' > lqosd/build.rs

    shopt -s globstar
    substituteInPlace **/*.rs \
      --replace-quiet '"/bin/chmod"' '"${lib.getExe' coreutils "chmod"}"' \
      --replace-quiet '"/bin/systemctl"' '"${lib.getExe' systemd "systemctl"}"' \
      --replace-quiet '"/bin/ip"' '"${lib.getExe' iproute2 "ip"}"' \
      --replace-quiet '"/sbin/ip"' '"${lib.getExe' iproute2 "ip"}"' \
      --replace-quiet '"/sbin/tc"' '"${lib.getExe' iproute2 "tc"}"' \
      --replace-quiet '"/sbin/ethtool"' '"${lib.getExe ethtool}"' \
      --replace-quiet '"/sbin/sysctl"' '"${lib.getExe' procps "sysctl"}"' \
      --replace-quiet '"/usr/bin/python3"' '"${lib.getExe' pythonEnv "python3"}"' \
      --replace-quiet 'Command::new("tc")' 'Command::new("${lib.getExe' iproute2 "tc"}")' \
      --replace-quiet 'Command::new("dot")' 'Command::new("${lib.getExe' graphviz "dot"}")'
    shopt -u globstar
  '';

  # upstream pins an exact esbuild version and download on mismatch
  env.ESBUILD_VERSION = esbuild.version;

  env.C_INCLUDE_PATH =
    let
      bpfstubs = writeTextFile {
        name = "bpf-stubs-workaround";
        destination = "/include/gnu/stubs-32.h";
        text = "";
      };
    in
    lib.makeIncludePath [
      bpfstubs
      libbpf
      stdenv.cc.libc
    ];

  nativeBuildInputs = [
    bpftools
    esbuild
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
    makeBinaryWrapper
    pkg-config
    python3
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    elfutils
    libbpf
    openssl
    zlib
  ];

  # web
  postBuild = ''
    pushd lqosd/src/node_manager/js_build
    bash ./esbuild.sh
    bash ./test-build-contract.sh
    popd
  '';

  # test suite expect configured system (root, NIC, etc.)
  doCheck = false;

  postInstall = ''
    libreqosDir=$out/lib/libreqos

    # see upstream build_dpkg.sh
    install -Dm0644 -t "$libreqosDir" ../*.py ../*.json ../*.csv ../*.example.toml ../lqos.example
    rm "$libreqosDir"/test*.py "$libreqosDir"/bakery_integration_*.py
    install -Dm0755 -t "$libreqosDir"/rust remove_pinned_maps.sh
    install -Dm0644 -t "$libreqosDir"/bin ../bin/*.service.example
    mv "$out"/lib/liblqos_python.so "$libreqosDir"/
    ln -s "$out"/bin/* "$libreqosDir"/bin/

    # web
    cp -r lqosd/src/node_manager/static2 "$libreqosDir"/bin/
    cp -r lqosd/src/node_manager/js_build/out/* "$libreqosDir"/bin/static2/

    ${lib.getExe' pythonEnv "python3"} -m compileall -q --invalidation-mode checked-hash "$libreqosDir"
    makeWrapper "${lib.getExe' pythonEnv "python3"}" "$out/bin/lqos_scheduler" \
      --add-flags "$libreqosDir/scheduler.py" \
      --prefix PATH : "${lib.makeBinPath [ iproute2 ]}" \
      --prefix PYTHONPATH : "$libreqosDir"
  '';

  passthru = {
    inherit pythonEnv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Traffic shaping and quality-of-experience management platform for ISPs";
    homepage = "https://github.com/LibreQoE/LibreQoS";
    changelog = "https://github.com/LibreQoE/LibreQoS/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
    mainProgram = "lqosd";
    platforms = lib.platforms.linux;
  };
})
