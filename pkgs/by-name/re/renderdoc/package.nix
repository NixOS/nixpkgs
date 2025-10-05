{
  lib,
  addDriverRunpath,
  autoconf,
  automake,
  bison,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libXdmcp,
  libglvnd,
  libpthreadstubs,
  makeWrapper,
  nix-update-script,
  pcre,
  pkg-config,
  # python3Packages.shiboken2 is currently broken
  python312Packages,
  qt5,
  stdenv,
  vulkan-loader,
  wayland,
  # Boolean flags
  waylandSupport ? true,
}:

let
  custom_swig = fetchFromGitHub {
    owner = "baldurk";
    repo = "swig";
    rev = "renderdoc-modified-7";
    hash = "sha256-RsdvxBBQvwuE5wSwL8OBXg5KMSpcO6EuMS0CzWapIpc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renderdoc";
  version = "1.40";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-420UV9I+jJ8sLOQVhfGfkGPqAnN+kgPy8k0rZLt5X+Y=";
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

  buildInputs = [
    libXdmcp
    libpthreadstubs
    python312Packages.pyside2
    python312Packages.pyside2-tools
    python312Packages.shiboken2
    qt5.qtbase
    qt5.qtsvg
    vulkan-loader
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
    pcre
    pkg-config
    python312Packages.python
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
  ];

  dontWrapQtApps = true;

  strictDeps = true;

  postUnpack = ''
    cp -r ${custom_swig} swig
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

  passthru.updateScript = nix-update-script { };

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
    platforms = lib.intersectLists lib.platforms.linux (lib.platforms.x86_64 ++ lib.platforms.i686);
  };
})
