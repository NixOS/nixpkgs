{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  yaml-cpp,
  glfw,
  libpng,
  libtirpc,
  liblxi,
  libsigcxx,
  zlib,
  wrapGAppsHook3,
  makeBinaryWrapper,
  writeDarwinBundle,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  glslang,
  spirv-tools,
  moltenvk,
  llvmPackages,
  hidapi,
  wayland,
  wayland-scanner,
}:

let
  version = "0.2.2";
in
stdenv.mkDerivation {
  pname = "scopehal-apps";
  inherit version;

  src = fetchFromGitHub {
    owner = "ngscopeclient";
    repo = "scopehal-apps";
    tag = "v${version}";
    hash = "sha256-LhkhSuoj6lHz3zB4U37qDkMxfV1UktIjwJvwbVGKDDM=";
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
    wayland-scanner
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    writeDarwinBundle
  ];

  buildInputs = [
    glfw
    glslang
    hidapi
    liblxi
    libpng
    libsigcxx
    vulkan-headers
    vulkan-loader
    yaml-cpp
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    libtirpc
    wayland
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
  ];

  cmakeFlags = [
    "-DNGSCOPECLIENT_PACKAGE_VERSION=v${version}"
    "-DNGSCOPECLIENT_PACKAGE_VERSION_LONG=v${version}-0"
  ];

  patches = [
    ./remove-required-lsb-release.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./remove-macos-bundle-fixup.patch
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
