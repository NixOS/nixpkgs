{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqb";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "libqb";
    tag = "v${finalAttrs.version}";
    # Upstream uses .gitattributes to inject information about the revision
    # hash and the refname into `configure.ac`, see:
    # - https://git-scm.com/docs/gitattributes#_export_subst and
    # - https://github.com/ClusterLabs/libqb/commit/d6875f29d6d1175f621e33d312fcace9a55f9094
    # Directly inject version and remove complicated logic
    # https://github.com/ClusterLabs/libqb/blob/d6875f29d6d1175f621e33d312fcace9a55f9094/configure.ac#L9-L15
    postFetch = ''
      substituteInPlace $out/configure.ac \
        --replace-fail "AC_INIT([libqb]," "AC_INIT([libqb], ${finalAttrs.version},"
      sed -i '/m4_esyscmd(\[build-aux\/git-version-gen/ , /\]),/ d' $out/configure.ac
    '';
    hash = "sha256-LhB7Q78heCmcgtcHqL+uEv0O2s4mXyfdTzmoCVqC0x0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxml2 ];

  # Remove configure check for linker flag `--enable-new-dtags`, which fails
  # on darwin. The flag is never used by the Makefile anyway.
  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/esac/ d' configure.ac
  '';

  meta = {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "Library providing high performance logging, tracing, ipc, and poll";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
