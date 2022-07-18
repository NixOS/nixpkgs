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
, fetchpatch
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
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "sha256-YXbyGUY/E8odjljDok+yYyU8yZSyUFc22zumrUuuXXQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Should dropped in next release after 1.4.5
    (fetchpatch {
      name = "usrbin-paths.patch";
      url = "https://github.com/containers/crun/commit/dd29f7f7f713c49784ac30f7cdca33b2ef94d5b8.patch";
      sha256 = "sha256-kHHix8CUL+c8HbOe5qx4PeF1P19113U4bRZyleMUjqk=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook go-md2man pkg-config python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ]
    # Criu currently only builds on x86_64-linux
    ++ lib.optional (lib.elem stdenv.hostPlatform.system criu.meta.platforms) criu;

  enableParallelBuilding = true;
  strictDeps = true;

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
