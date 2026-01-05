{
  stdenv,
  lib,
  addDriverRunpath,
  fetchFromGitHub,
  pkg-config,
  elfutils,
  libcap,
  libseccomp,
  rpcsvc-proto,
  libtirpc,
  makeWrapper,
  removeReferencesTo,
  replaceVars,
  applyPatches,
  nvidia-modprobe,
  go,
}:
let
  modprobeVersion = "550.54.14";
  patchedModprobe = applyPatches {
    src = nvidia-modprobe.src.override {
      version = modprobeVersion;
      hash = "sha256-iBRMkvOXacs/llTtvc/ZC5i/q9gc8lMuUHxMbu8A+Kg=";
    };
    patches = [
      (replaceVars ./modprobe.patch {
        inherit modprobeVersion;
      })
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libnvidia-container";
  version = "1.17.8";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libnvidia-container";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OzjcYxnWjzgmrjERyPN3Ch3EQj4t1J5/TbATluoDESg=";
  };

  patches = [
    # Locations of nvidia driver libraries are not resolved via ldconfig which
    # doesn't get used on NixOS.
    (replaceVars ./0001-ldcache-don-t-use-ldcache.patch {
      inherit (addDriverRunpath) driverLink;
    })

    # Use both PATH and the legacy nvidia-docker paths (NixOS artifacts)
    # for binary lookups.
    # TODO: Remove the legacy compatibility once nvidia-docker is removed
    # from NixOS.
    (replaceVars ./0002-nvc-nvidia-docker-compatible-binary-lookups.patch {
      inherit (addDriverRunpath) driverLink;
    })

    # fix bogus struct declaration
    ./0003-nvc-fix-struct-declaration.patch
  ];

  postPatch = ''
    sed -i \
      -e 's/^REVISION ?=.*/REVISION = ${finalAttrs.src.tag}/' \
      -e 's/^COMPILER :=.*/COMPILER = $(CC)/' \
      mk/common.mk

    sed -i \
      -e 's/^GIT_TAG ?=.*/GIT_TAG = ${finalAttrs.version}/' \
      -e 's/^GIT_COMMIT ?=.*/GIT_COMMIT = ${finalAttrs.src.tag}/' \
      versions.mk

    mkdir -p deps/src/nvidia-modprobe-${modprobeVersion}
    cp -r ${patchedModprobe}/* deps/src/nvidia-modprobe-${modprobeVersion}
    chmod -R u+w deps/src
    pushd deps/src

    touch nvidia-modprobe-${modprobeVersion}/.download_stamp
    popd

    # 1. replace DESTDIR=$(DEPS_DIR) with empty strings to prevent copying
    #    things into deps/src/nix/store
    # 2. similarly, remove any paths prefixed with DEPS_DIR
    # 3. prevent building static libraries because we don't build static
    #    libtirpc (for now)
    # 4. prevent installation of static libraries because of step 3
    # 5. prevent installation of libnvidia-container-go.so twice
    # 6. Replace pkg-config and objcopy with target platform's one
    # 7. Stub ldconfig
    #
    sed -i Makefile \
      -e 's#DESTDIR=\$(DEPS_DIR)#DESTDIR=""#g' \
      -e 's#\$(DEPS_DIR)\$#\$#g' \
      -e 's#all: shared static tools#all: shared tools#g' \
      -e '/$(INSTALL) -m 644 $(LIB_STATIC) $(DESTDIR)$(libdir)/d' \
      -e '/$(INSTALL) -m 755 $(libdir)\/$(LIBGO_SHARED) $(DESTDIR)$(libdir)/d' \
      -e "s,pkg-config,$PKG_CONFIG,g"
    substituteInPlace mk/common.mk \
      --replace-fail objcopy '$(OBJCOPY)' \
      --replace-fail ldconfig true
  '';

  # Recreate library symlinks which ldconfig would have created
  postFixup = ''
    for lib in libnvidia-container libnvidia-container-go; do
      rm -f "$out/lib/$lib.so"
      ln -s "$out/lib/$lib.so.${finalAttrs.version}" "$out/lib/$lib.so.1"
      ln -s "$out/lib/$lib.so.1" "$out/lib/$lib.so"
    done
  '';

  enableParallelBuilding = true;

  preBuild = ''
    HOME="$(mktemp -d)"
  '';

  env = {
    NIX_CFLAGS_COMPILE = toString [ "-I${lib.getInclude libtirpc}/include/tirpc" ];
    CGO_ENABLED = "1"; # Needed for cross-compilation
    GOFLAGS = "-trimpath"; # Don't include paths to Go stdlib to resulting binary
    inherit (go) GOARCH GOOS;
  };
  NIX_LDFLAGS = [
    "-L${lib.getLib libtirpc}/lib"
    "-ltirpc"
  ];

  nativeBuildInputs = [
    pkg-config
    go
    rpcsvc-proto
    makeWrapper
    removeReferencesTo
  ];

  buildInputs = [
    elfutils
    libcap
    libseccomp
    libtirpc
  ];

  makeFlags = [
    "WITH_LIBELF=yes"
    "prefix=$(out)"
    # we can't use the WITH_TIRPC=yes flag that exists in the Makefile for the
    # same reason we patch out the static library use of libtirpc so we set the
    # define in CFLAGS
    "CFLAGS=-DWITH_TIRPC"
  ];

  postInstall =
    let
      inherit (addDriverRunpath) driverLink;
      libraryPath = lib.makeLibraryPath [
        "$out"
        driverLink
        "${driverLink}-32"
      ];
    in
    ''
      remove-references-to -t "${go}" $out/lib/libnvidia-container-go.so.${finalAttrs.version}
      wrapProgram $out/bin/nvidia-container-cli --prefix LD_LIBRARY_PATH : ${libraryPath}
    '';
  disallowedReferences = [ go ];

  meta = {
    homepage = "https://github.com/NVIDIA/libnvidia-container";
    description = "NVIDIA container runtime library";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "nvidia-container-cli";
    maintainers = with lib.maintainers; [
      cpcloud
      msanft
      katexochen
    ];
  };
})
