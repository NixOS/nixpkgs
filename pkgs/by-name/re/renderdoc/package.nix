{
  lib,
  addDriverRunpath,
  autoconf,
  automake,
  bison,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libxdmcp,
  libglvnd,
  libpthread-stubs,
  makeWrapper,
  nix-update-script,
  pcre2,
  pkg-config,
  python3,
  qt5,
  stdenv,
  vulkan-loader,
  wayland,
  # Boolean flags
  waylandSupport ? true,
}:

let
  # forked from swig v3 in 2017
  # primarily to include https://github.com/swig/swig/pull/251
  # (cherry-picked as https://github.com/swig/swig/commit/8d79491a329825ad24294509fc6a0b0a0b8947c4)
  custom_swig = fetchFromGitHub {
    owner = "baldurk";
    repo = "swig";
    rev = "renderdoc-modified-7";
    hash = "sha256-RsdvxBBQvwuE5wSwL8OBXg5KMSpcO6EuMS0CzWapIpc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renderdoc";
  version = "1.44";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EInMFJMs+0bNSWmNP/f17pFCV9tJj6Ys3tZY6D69c/E=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    (fetchpatch {
      # https://github.com/baldurk/renderdoc/issues/2945
      # https://github.com/baldurk/renderdoc/commit/adf8acbccd642c8bc62256fb5580795320364895
      name = "devendor-pcre.patch";
      url = "https://github.com/baldurk/renderdoc/commit/adf8acbccd642c8bc62256fb5580795320364895.patch?full_index=1";
      hash = "sha256-uQoSVmgU09tw7ccTnH1MrisDisTUbaXTelA1YdsYPlM=";
      revert = true;
    })
  ];
  swig_patches = [
    # use PCRE2 instead of PCRE
    (fetchpatch {
      name = "renderdoc-swig-pcre2-1.patch";
      url = "https://src.fedoraproject.org/rpms/renderdoc/raw/19ce666d120a229e5c1ab62fc142610ab3b21b3c/f/renderdoc-swig-pcre2-1.patch";
      hash = "sha256-xuqHu72vAbxFELNTfJT5SbQOsnG/ee++MZgpuEGLT/w=";
    })
    (fetchpatch {
      name = "renderdoc-swig-pcre2-2.patch";
      url = "https://src.fedoraproject.org/rpms/renderdoc/raw/19ce666d120a229e5c1ab62fc142610ab3b21b3c/f/renderdoc-swig-pcre2-2.patch";
      hash = "sha256-LUm5Ekmccy4x+hR+iK49zJc75VxuhDhpNw8rkVnn4rc=";
    })
  ];
  postPatch = ''
    pushd ../swig
    prePatch="" postPatch="" patches="$swig_patches" runPhase patchPhase
    popd
  '';

  buildInputs = [
    libxdmcp
    libpthread-stubs
    qt5.qtbase
    qt5.qtsvg
    vulkan-loader
    # TODO: make sure pyrenderdoc is installed properly
    # TODO: unbreak shiboken2 on python>3.12
    # python312Packages.pyside2
    # python312Packages.pyside2-tools
    # python312Packages.shiboken2
  ]
  ++ lib.optionals waylandSupport [
    wayland
  ];

  nativeBuildInputs = [
    addDriverRunpath
    autoconf
    automake
    bison
    cmake
    makeWrapper
    pcre2
    pkg-config
    python3
    qt5.qtx11extras
    qt5.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeFeature "BUILD_VERSION_HASH" finalAttrs.src.rev)
    (lib.cmakeFeature "BUILD_VERSION_DIST_NAME" "NixOS")
    (lib.cmakeFeature "BUILD_VERSION_DIST_VER" finalAttrs.version)
    (lib.cmakeFeature "BUILD_VERSION_DIST_CONTACT" "https://github.com/NixOS/nixpkgs/")
    (lib.cmakeBool "BUILD_VERSION_STABLE" true)
    (lib.cmakeBool "ENABLE_UNSUPPORTED_EXPERIMENTAL_POSSIBLY_BROKEN_WAYLAND" waylandSupport)
    # TODO: build python bindings
    # https://github.com/NixOS/nixpkgs/issues/525939
    (lib.cmakeBool "ENABLE_PYRENDERDOC" false)
    (lib.cmakeBool "QRENDERDOC_ENABLE_PYSIDE2" false)
  ];

  dontWrapQtApps = true;

  strictDeps = true;

  postUnpack = ''
    cp -r ${finalAttrs.passthru.custom_swig} swig
    chmod -R +w swig
    patchShebangs swig/autogen.sh
  '';

  # TODO: define these in the above array via placeholders, once those are
  # widely supported
  preConfigure = ''
    cmakeFlagsArray+=(
      "-DRENDERDOC_SWIG_PACKAGE=$PWD/../swig"
      "-DVULKAN_LAYER_FOLDER=$out/share/vulkan/implicit_layer.d/"
     )
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath [
        libglvnd
        vulkan-loader
      ];
    in
    ''
      wrapQtApp $out/bin/qrenderdoc \
        --set QT_QPA_PLATFORM "wayland;xcb" \
        --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
      wrapProgram $out/bin/renderdoccmd \
        --suffix LD_LIBRARY_PATH : "$out/lib:${libPath}"
    '';

  # The only documentation for this so far is in the setup-hook.sh script from
  # add-opengl-runpath
  postFixup = ''
    addDriverRunpath $out/lib/librenderdoc.so
  '';

  passthru = {
    inherit custom_swig;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://renderdoc.org/";
    description = "Single-frame graphics debugger";
    longDescription = ''
      RenderDoc is a free MIT licensed stand-alone graphics debugger that
      allows quick and easy single-frame capture and detailed introspection
      of any application using Vulkan, D3D11, OpenGL or D3D12 across
      Windows 7 - 10, Linux or Android.
    '';
    license = lib.licenses.mit;
    mainProgram = "renderdoccmd";
    maintainers = with lib.maintainers; [
      pbsds
      ShyAssassin
    ];
    platforms = lib.intersectLists lib.platforms.linux (
      lib.platforms.x86_64 ++ lib.platforms.i686 ++ lib.platforms.aarch64
    );
  };
})
