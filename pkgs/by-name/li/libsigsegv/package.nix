{
  lib,
  stdenv,
  fetchurl,
  enableSigbusFix ? false, # required by kernels < 3.18.6
}:

stdenv.mkDerivation rec {
  pname = "libsigsegv";
  version = "2.14";

  src = fetchurl {
    url = "mirror://gnu/libsigsegv/libsigsegv-${version}.tar.gz";
    sha256 = "sha256-zaw5QYAzZM+BqQhJm+t5wgDq1gtrW0DK0ST9HgbKopU=";
  };

  patches = if enableSigbusFix then [ ./sigbus_fix.patch ] else null;

  doCheck = true; # not cross;

  meta = {
    homepage = "https://www.gnu.org/software/libsigsegv/";
    description = "Library to handle page faults in user mode";

    longDescription = ''
      GNU libsigsegv is a library for handling page faults in user mode. A
      page fault occurs when a program tries to access to a region of memory
      that is currently not available. Catching and handling a page fault is
      a useful technique for implementing pageable virtual memory,
      memory-mapped access to persistent databases, generational garbage
      collectors, stack overflow handlers, distributed shared memory, and
      more.
    '';

    license = lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
