{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libunwind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gperftools";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "gperftools";
    repo = "gperftools";
    tag = "gperftools-${finalAttrs.version}";
    sha256 = "sha256-Tm+sYKwFSHAxOALgr9UGv7vBMlWqUymXsvNu7Sku6Kk=";
  };

  patches = [
    # Add the --disable-general-dynamic-tls configure option:
    # https://bugzilla.redhat.com/show_bug.cgi?id=1483558
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gperftools/raw/88ce8ee43a12b1a8146781a1b4d9abbd8df8af0e/f/gperftools-2.17-disable-generic-dynamic-tls.patch";
      hash = "sha256-IOLUf9mCEA+fVSJKU94akcnXTIm7+t+S9cjBHsEDwFA=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  # tcmalloc uses libunwind in a way that works correctly only on non-ARM dynamically linked linux
  buildInputs = lib.optional (
    stdenv.hostPlatform.isLinux && !(stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isStatic)
  ) libunwind;

  # Disable general dynamic TLS on AArch to support dlopen()'ing the library:
  # https://bugzilla.redhat.com/show_bug.cgi?id=1483558
  configureFlags = lib.optional stdenv.hostPlatform.isAarch "--disable-general-dynamic-tls";

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_XOPEN_SOURCE";

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = {
    changelog = "https://github.com/gperftools/gperftools/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/gperftools/gperftools";
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vcunat ];
  };
})
