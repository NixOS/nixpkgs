{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, libunwind
, perl
}:

stdenv.mkDerivation rec {
  pname = "gperftools";
  version = "2.15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-3ibr8AHzo7txX1U+9oOWA60qeeJs/OGeevv+sgBwQa0=";
  };

  patches = [
    # Add the --disable-general-dynamic-tls configure option:
    # https://bugzilla.redhat.com/show_bug.cgi?id=1483558
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gperftools/raw/f62d87a34f56f64fb8eb86727e34fbc2d3f5294a/f/gperftools-2.7.90-disable-generic-dynamic-tls.patch";
      sha256 = "02falhpaqkl27hl1dib4yvmhwsddmgbw0krb46w31fyf3awb2ydv";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  # tcmalloc uses libunwind in a way that works correctly only on non-ARM dynamically linked linux
  buildInputs = [ perl ]
             ++ lib.optional (stdenv.hostPlatform.isLinux && !(stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isStatic )) libunwind;

  # Disable general dynamic TLS on AArch to support dlopen()'ing the library:
  # https://bugzilla.redhat.com/show_bug.cgi?id=1483558
  configureFlags = lib.optional stdenv.hostPlatform.isAarch
    "--disable-general-dynamic-tls";

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin
    "-D_XOPEN_SOURCE";

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/gperftools/gperftools";
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat ];
  };
}
