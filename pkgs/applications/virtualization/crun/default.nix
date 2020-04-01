{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, go-md2man
, pkgconfig
, libcap
, libseccomp
, python3
, systemd
, yajl
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
    "test_start.py"
    "test_uid_gid.py"
    "test_update.py"
    "tests_libcrun_utils"
  ];

in
stdenv.mkDerivation rec {
  pname = "crun";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "0c5acf916yv2zv3xjvxk1sa4h3n2wljc5hw61php7q37pbjc1ppn";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook go-md2man pkgconfig python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ];

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

  meta = with lib; {
    description = "A fast and lightweight fully featured OCI runtime and C library for running containers";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
