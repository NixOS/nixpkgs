{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  go-md2man,
  pkg-config,
  libcap,
  libseccomp,
  python3,
<<<<<<< HEAD
  systemdMinimal,
  yajl,
  nixosTests,
  criu,
  versionCheckHook,
=======
  systemd,
  yajl,
  nixosTests,
  criu,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "crun";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "crun";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-WBAwyDODMrUDlgonRbxaNQ+aN8K6YicY2JVArXDJem8=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse HEAD > COMMIT
      rm -rf .git
    '';
=======
    rev = version;
    hash = "sha256-WBAwyDODMrUDlgonRbxaNQ+aN8K6YicY2JVArXDJem8=";
    fetchSubmodules = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    systemdMinimal
=======
    systemd
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    yajl
  ];

  enableParallelBuilding = true;
  strictDeps = true;

<<<<<<< HEAD
  env = {
    NIX_LDFLAGS = "-lcriu";
  };
=======
  NIX_LDFLAGS = "-lcriu";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # we need this before autoreconfHook does its thing in order to initialize
  # config.h with the correct values
  postPatch = ''
<<<<<<< HEAD
    echo ${finalAttrs.version} > .tarball-version
    echo "#define GIT_VERSION \"$(cat COMMIT)\"" > git-version.h

    ${lib.concatMapStringsSep "\n" (
      e: "substituteInPlace Makefile.am --replace-fail 'tests/${e}' ''"
=======
    echo ${version} > .tarball-version
    echo '#define GIT_VERSION "${src.rev}"' > git-version.h

    ${lib.concatMapStringsSep "\n" (
      e: "substituteInPlace Makefile.am --replace 'tests/${e}' ''"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ) disabledTests}
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests) podman; };

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/containers/crun/releases/tag/${finalAttrs.version}";
=======
  meta = {
    changelog = "https://github.com/containers/crun/releases/tag/${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Fast and lightweight fully featured OCI runtime and C library for running containers";
    homepage = "https://github.com/containers/crun";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.podman ];
    mainProgram = "crun";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
