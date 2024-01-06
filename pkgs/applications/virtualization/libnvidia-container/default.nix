{ stdenv
, lib
, addOpenGLRunpath
, fetchFromGitHub
, pkg-config
, elfutils
, libcap
, libseccomp
, rpcsvc-proto
, libtirpc
, makeWrapper
, substituteAll
, removeReferencesTo
, bmake
, go
}:
let
  modprobeVersion = "495.44";
  nvidia-modprobe = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = modprobeVersion;
    sha256 = "sha256-Y3ZOfge/EcmhqI19yWO7UfPqkvY1CHHvFC5l9vYyGuU=";
  };
  modprobePatch = substituteAll {
    src = ./modprobe.patch;
    inherit modprobeVersion;
  };
in
stdenv.mkDerivation rec {
  pname = "libnvidia-container";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KOLeZKTdXiDuuziAhavlRPwDD5aPdJSoaPLtCGYKLUY=";
  };

  patches = [
    # locations of nvidia-driver libraries are not resolved via ldconfig which
    # doesn't get used on NixOS. Additional support binaries like nvidia-smi
    # are not resolved via the environment PATH but via the derivation output
    # path.
    ./0001-libnvc-ldconfig-and-PATH-fixes.patch

    # fix bogus struct declaration
    ./inline-c-struct.patch
  ];

  postPatch = ''
    sed -i \
      -e 's/^REVISION ?=.*/REVISION = ${src.rev}/' \
      -e 's/^COMPILER :=.*/COMPILER = $(CC)/' \
      mk/common.mk

    mkdir -p deps/src/nvidia-modprobe-${modprobeVersion}
    cp -r ${nvidia-modprobe}/* deps/src/nvidia-modprobe-${modprobeVersion}
    chmod -R u+w deps/src
    pushd deps/src

    patch -p0 < ${modprobePatch}
    touch nvidia-modprobe-${modprobeVersion}/.download_stamp
    popd

    # 1. replace DESTDIR=$(DEPS_DIR) with empty strings to prevent copying
    #    things into deps/src/nix/store
    # 2. similarly, remove any paths prefixed with DEPS_DIR
    # 3. prevent building static libraries because we don't build static
    #    libtirpc (for now)
    # 4. prevent installation of static libraries because of step 3
    # 5. prevent installation of libnvidia-container-go.so twice
    sed -i Makefile \
      -e 's#DESTDIR=\$(DEPS_DIR)#DESTDIR=""#g' \
      -e 's#\$(DEPS_DIR)\$#\$#g' \
      -e 's#all: shared static tools#all: shared tools#g' \
      -e '/$(INSTALL) -m 644 $(LIB_STATIC) $(DESTDIR)$(libdir)/d' \
      -e '/$(INSTALL) -m 755 $(libdir)\/$(LIBGO_SHARED) $(DESTDIR)$(libdir)/d'
  '';

  enableParallelBuilding = true;

  preBuild = ''
    HOME="$(mktemp -d)"
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-L${libtirpc.dev}/lib" "-ltirpc" ];

  nativeBuildInputs = [
    bmake
    go
    makeWrapper
    pkg-config
    removeReferencesTo
    rpcsvc-proto
  ];

  buildInputs = [ elfutils libcap libseccomp libtirpc ];

  # 2024-01-05: Upstream manually launches bmake from their top-level Makefile.
  # This is almost surely going to break very soon, but let's give it a chance.
  dontUseBmakeBuild = true;
  makeTargets = [ "all" ];
  makeFlags = [
    "WITH_LIBELF=yes"
    "prefix=$(out)"
    # we can't use the WITH_TIRPC=yes flag that exists in the Makefile for the
    # same reason we patch out the static library use of libtirpc so we set the
    # define in CFLAGS
    "CFLAGS=-DWITH_TIRPC"

    # Makefile asserts these are set
    "MAJOR=${lib.versions.major version}"
    "MINOR=${lib.versions.minor version}"
    "PATCH=${lib.versions.patch version}"
  ];

  dontUseBmakeCheck = true;
  dontUseBmakeInstall = true;
  dontUseBmakeDist = true;
  postInstall =
    let
      inherit (addOpenGLRunpath) driverLink;
      libraryPath = lib.makeLibraryPath [ "$out" driverLink "${driverLink}-32" ];
    in
    ''
      remove-references-to -t "${go}" $out/lib/libnvidia-container-go.so*
      wrapProgram $out/bin/nvidia-container-cli --prefix LD_LIBRARY_PATH : ${libraryPath}
    '';
  disallowedReferences = [ go ];

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/libnvidia-container";
    description = "NVIDIA container runtime library";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "nvidia-container-cli";
    maintainers = with maintainers; [ cpcloud ];
  };
}
