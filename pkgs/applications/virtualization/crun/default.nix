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
, system
, fetchpatch
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
    "test_start.py"
    "test_uid_gid.py"
    "test_update.py"
    "tests_libcrun_utils"
  ];

in
stdenv.mkDerivation rec {
  pname = "crun";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "sha256-VjMpfj2qUQdhqdnLpZsYigfo2sM7gNl0GrE4nitp13g=";
    fetchSubmodules = true;
  };

  patches = [
    # For 0.18 some tests switched to static builds, this was reverted after 0.18 was released
    (fetchpatch {
      url = "https://github.com/containers/crun/commit/d26579bfe56aa36dd522745d47a661ce8c70d4e7.patch";
      sha256 = "1xmc0wj0j2xcg0915vxn0pplc4s94rpmw0s5g8cyf8dshfl283f9";
    })
  ];

  nativeBuildInputs = [ autoreconfHook go-md2man pkg-config python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ]
    # Criu currently only builds on x86_64-linux
    ++ lib.optional (lib.elem system criu.meta.platforms) criu;

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
