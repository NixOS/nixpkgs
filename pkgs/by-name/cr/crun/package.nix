{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  go-md2man,
  pkg-config,
  libcap,
  libkrun,
  libkrun-sev,
  libseccomp,
  python3,
  systemdMinimal,
  yajl,
  nixosTests,
  criu,
  versionCheckHook,
  withLibkrun ? lib.meta.availableOn stdenv.hostPlatform libkrun,
  withLibkrunSEV ? false,
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
  pname = "crun";
  version = "1.27";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "crun";
    tag = finalAttrs.version;
    hash = "sha256-AhNKSwKZdm/8rZsDIGwNdNcVUXFvEGQecGw3pZYjmZw=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > COMMIT
      rm -rf .git
    '';
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
    systemdMinimal
    yajl
  ]
  ++ lib.optionals withLibkrun [
    libkrun
  ]
  ++ lib.optionals withLibkrunSEV [
    libkrun-sev
  ];

  configureFlags = lib.optionals withLibkrun [
    "--with-libkrun"
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  env = {
    NIX_LDFLAGS = "-lcriu";
  };

  # we need this before autoreconfHook does its thing in order to initialize
  # config.h with the correct values
  postPatch = ''
    echo ${finalAttrs.version} > .tarball-version
    echo "#define GIT_VERSION \"$(cat COMMIT)\"" > git-version.h

    ${lib.concatMapStringsSep "\n" (
      e: "substituteInPlace Makefile.am --replace-fail 'tests/${e}' ''"
    ) disabledTests}
  ''
  + lib.optionalString withLibkrun ''
    substituteInPlace src/libcrun/handlers/krun.c \
      --replace-fail '"libkrun.so.1"' '"${libkrun}/lib/libkrun.so.1"'
  ''
  + lib.optionalString withLibkrunSEV ''
    substituteInPlace src/libcrun/handlers/krun.c \
      --replace-fail '"libkrun-sev.so.1"' '"${libkrun-sev}/lib/libkrun-sev.so.1"'
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests) podman; };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/containers/crun/releases/tag/${finalAttrs.version}";
    description = "Fast and lightweight fully featured OCI runtime and C library for running containers";
    homepage = "https://github.com/containers/crun";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.podman ];
    mainProgram = "crun";
  };
})
