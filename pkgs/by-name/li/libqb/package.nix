{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "libqb";
  version = "2.0.9";
=======
stdenv.mkDerivation rec {
  pname = "libqb";
  version = "2.0.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "libqb";
<<<<<<< HEAD
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

=======
    rev = "v${version}";
    sha256 = "sha256-ZjxC7W4U8T68mZy/OvWj/e4W9pJIj2lVDoEjxXYr/G8=";
  };

  patches = [
    # add a declaration of fdatasync, missing on darwin https://github.com/ClusterLabs/libqb/pull/496
    (fetchpatch {
      url = "https://github.com/ClusterLabs/libqb/commit/255ccb70ee19cc0c82dd13e4fd5838ca5427795f.patch";
      hash = "sha256-6x4B3FM0XSRIeAly8JtMOGOdyunTcbaDzUeBZInXR4U=";
    })
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxml2 ];

<<<<<<< HEAD
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
=======
  postPatch = ''
    sed -i '/# --enable-new-dtags:/,/--enable-new-dtags is required/ d' configure.ac
  '';

  meta = with lib; {
    homepage = "https://github.com/clusterlabs/libqb";
    description = "Library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
