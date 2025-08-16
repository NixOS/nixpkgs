{
  stdenv,
  lib,
  fetchgit,
  autoreconfHook,
  go-md2man,
  pkg-config,
  libcap,
  libseccomp,
  python3,
  systemd,
  yajl,
  nixosTests,
  criu,
  libkrun,
  libkrun-sev,
  nix-update-script,
}:

let
  # these tests require additional permissions
  disabledTests = [
    "test_capabilities.py"
    "test_cwd.py"
    "test_delete.py"
    "test_detach.py"
    "test_exec.py"
    "test_hooks.py"
    "test_hostname.py"
    "test_oci_features"
    "test_paths.py"
    "test_pid.py"
    "test_pid_file.py"
    "test_preserve_fds.py"
    "test_resources"
    "test_seccomp"
    "test_start.py"
    "test_uid_gid.py"
    "test_update.py"
    "tests_libcrun_utils"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "crun-krun";
  version = "1.22";

  src = fetchgit {
    url = "https://github.com/containers/crun";
    sha256 = "sha256-IZzG+khiJb5LBPqUOuZbexvFppjyLE216QUndllylu0=";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    go-md2man
    pkg-config
    python3
  ];

  buildInputs = [
    criu
    libcap
    libseccomp
    libkrun
    libkrun-sev
    systemd
    yajl
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  NIX_LDFLAGS = "-lcriu -lkrun -lkrun-sev";

  # we need this before autoreconfHook does its thing in order to initialize
  # config.h with the correct values
  postPatch = ''
    echo ${finalAttrs.version} > .tarball-version
    echo '#define GIT_VERSION "${finalAttrs.src.rev}"' > git-version.h

    ${lib.concatMapStringsSep "\n" (
      e: "substituteInPlace Makefile.am --replace 'tests/${e}' ''"
    ) disabledTests}
  '';

  doCheck = true;

  configurePhase = ''
    runHook preConfigure

    mkdir -p /build
    chmod +w /build
    ./autogen.sh
    ./configure \
      --prefix=$out \
      --enable-shared \
      --enable-dynamic \
      --with-libkrun

    runHook postConfigure
  '';

  passthru.tests = { inherit (nixosTests) podman; };
  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/containers/crun/releases/tag/${finalAttrs.version}";
    description = "Fast and lightweight fully featured OCI runtime and C library for running containers";
    homepage = "https://github.com/containers/crun";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ miampf ];
    mainProgram = "krun";
  };
})
