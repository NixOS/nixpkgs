{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, go-md2man
, pkg-config
, libcap
, libseccomp
, python3
, systemd
, yajl
, nixosTests
, criu
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
stdenv.mkDerivation rec {
  pname = "crun";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    hash = "sha256-ZLkpwNxhTssp5RZ041+/mveq7Sct8fVzsdt8X319V1Q=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook go-md2man pkg-config python3 ];

  buildInputs = [ criu libcap libseccomp systemd yajl ];

  enableParallelBuilding = true;
  strictDeps = true;

  NIX_LDFLAGS = "-lcriu";

  # we need this before autoreconfHook does its thing in order to initialize
  # config.h with the correct values
  postPatch = ''
    echo ${version} > .tarball-version
    echo '#define GIT_VERSION "${src.rev}"' > git-version.h

    ${lib.concatMapStringsSep "\n" (e:
      "substituteInPlace Makefile.am --replace 'tests/${e}' ''"
    ) disabledTests}
  '';

  doCheck = true;

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/crun/releases/tag/${version}";
    description = "A fast and lightweight fully featured OCI runtime and C library for running containers";
    homepage = "https://github.com/containers/crun";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    mainProgram = "crun";
  };
}
