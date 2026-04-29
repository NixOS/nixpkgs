{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
  cairomm,
  yaml-cpp,
  glfw,
  libtirpc,
  liblxi,
  libsigcxx,
  glew,
  zstd,
  wrapGAppsHook3,
  makeBinaryWrapper,
  writeDarwinBundle,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  glslang,
  spirv-tools,
  ffts,
  moltenvk,
  llvmPackages,
  hidapi,
}:

let
  version = "0.1.1";
in
stdenv.mkDerivation {
  pname = "scopehal-apps";
  version = "${version}";

  src = fetchFromGitHub {
    owner = "ngscopeclient";
    repo = "scopehal-apps";
    tag = "v${version}";
    hash = "sha256-7ZXfxfRa+1fbMj2IDF/boNL/qCy4i9IyMnzIgOZunDw=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    shaderc
    spirv-tools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    writeDarwinBundle
  ];

  buildInputs = [
    cairomm
    glew
    glfw
    glslang
    liblxi
    libsigcxx
    vulkan-headers
    vulkan-loader
    vulkan-tools
    yaml-cpp
    zstd
    hidapi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    ffts
    gtkmm3
    libtirpc
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
  ];

  cmakeFlags = [
    "-DNGSCOPECLIENT_PACKAGE_VERSION=v${version}"
    "-DNGSCOPECLIENT_PACKAGE_VERSION_LONG=v${version}-0"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # error: variable 'empty_string' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
    "-Wno-error=uninitialized"
  ];

  patches = [
    ./remove-required-lsb-release.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./remove-brew-molten-vk-lookup.patch
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv -v $out/bin/ngscopeclient $out/bin/.ngscopeclient-unwrapped
    makeWrapper $out/bin/.ngscopeclient-unwrapped $out/bin/ngscopeclient \
      --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ vulkan-loader ]}"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/ngscopeclient.app/Contents/{MacOS,Resources}

    install -m644 {../src/ngscopeclient/icons/macos,$out/Applications/ngscopeclient.app/Contents/Resources}/ngscopeclient.icns

    write-darwin-bundle $out ngscopeclient ngscopeclient ngscopeclient
  '';

  meta = {
    description = "Advanced test & measurement remote control and analysis suite";
    homepage = "https://www.ngscopeclient.org/";
    license = lib.licenses.bsd3;
    mainProgram = "ngscopeclient";
    maintainers = with lib.maintainers; [
      bgamari
      carlossless
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
