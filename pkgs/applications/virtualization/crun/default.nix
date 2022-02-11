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
    "test_detach.py"
    "test_exec.py"
    "test_hooks.py"
    "test_hostname.py"
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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "sha256-zGtHO8CgpbXTh8nZ6WA0ocakzLjL/PW2IULI5QSEPVI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook go-md2man pkg-config python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ]
    # Criu currently only builds on x86_64-linux
    ++ lib.optional (lib.elem stdenv.hostPlatform.system criu.meta.platforms) criu;

  enableParallelBuilding = true;

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
    description = "A fast and lightweight fully featured OCI runtime and C library for running containers";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
