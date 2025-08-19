{
  stdenv,
  gn,
  ninja,
  llvmPackages_21,
  gclient2nix,
  pkg-config,
  glib,
  python3,
  symlinkJoin,
  lib,
  xorg,
  wayland,
  pciutils,
  libGL,
}:
let
  llvmPackages = llvmPackages_21;
  llvmMajorVersion = lib.versions.major llvmPackages.llvm.version;
  arch = stdenv.hostPlatform.parsed.cpu.name;
  triplet = lib.getAttr arch {
    "x86_64" = "x86_64-unknown-linux-gnu";
    "aarch64" = "aarch64-unknown-linux-gnu";
  };

  clang = symlinkJoin {
    name = "angle-clang-llvm-join";
    paths = [
      llvmPackages.llvm
      llvmPackages.clang
    ];
    postBuild = ''
      mkdir -p $out/lib/clang/${llvmMajorVersion}/lib/
      ln -s $out/resource-root/lib/linux \
        $out/lib/clang/${llvmMajorVersion}/lib/${triplet}
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "angle";
  version = "7258";

  gclientDeps = gclient2nix.importGclientDeps ./info.json;
  sourceRoot = "src";
  strictDeps = true;

  nativeBuildInputs = [
    gn
    ninja
    gclient2nix.gclientUnpackHook
    pkg-config
    python3
    llvmPackages.bintools
  ];

  buildInputs = [
    glib
    xorg.libxcb.dev
    xorg.libX11.dev
    xorg.libXext.dev
    xorg.libXi
    wayland.dev
    pciutils
    libGL
  ];

  gnFlags = [
    "is_debug=false"
    "use_sysroot=false"
    "clang_base_path=\"${clang}\""
    "angle_build_tests=false"
    "concurrent_links=1"
    "use_custom_libcxx=true"
    "angle_enable_swiftshader=false"
    "angle_enable_wgpu=false"
  ];

  patches = [
    # https://issues.chromium.org/issues/432275627
    # https://chromium-review.googlesource.com/c/chromium/src/+/6761936/2/build/config/compiler/BUILD.gn
    ./fix-uninitialized-const-pointer-error-001.patch
  ];

  postPatch = ''
    substituteInPlace build/config/clang/BUILD.gn \
      --replace-fail \
        "_dir = \"${triplet}\"" \
        "_dir = \"${triplet}\"
         _suffix = \"-${arch}\""

    cat > build/config/gclient_args.gni <<EOF
    # Generated from 'DEPS'
    checkout_angle_internal = false
    checkout_angle_mesa = false
    checkout_angle_restricted_traces = false
    generate_location_tags = false
    EOF
  '';

  installPhase = ''
    runHook preInstallPhase

    install -v -m755 -D *.so *.so.1 -t "$out/lib"
    install -v -m755 -D \
      angle_shader_translator \
      gaussian_distribution_gentables \
      -t "$out/bin"

    cp -rv ../../include "$out"

    mkdir -p $out/lib/pkgconfig

    cat > $out/lib/pkgconfig/angle.pc <<EOF
    prefix=${placeholder "out"}
    exec_prefix=''${prefix}
    libdir=''${prefix}/lib
    includedir=''${prefix}/include

    Name: angle
    Description: ${finalAttrs.meta.description}

    URL: ${finalAttrs.meta.homepage}
    Version: ${lib.versions.major finalAttrs.version}
    Libs: -L''${libdir} -l${
      lib.concatStringsSep " -l" [
        "EGL"
        "EGL_vulkan_secondaries"
        "GLESv1_CM"
        "GLESv2"
        "GLESv2_vulkan_secondaries"
        "GLESv2_with_capture"
        "VkICD_mock_icd"
        "feature_support"
      ]
    }
    Cflags: -I''${includedir}
    EOF

    runHook postInstallPhase
  '';

  meta = {
    description = "Conformant OpenGL ES implementation for Windows, Mac, Linux, iOS and Android";
    longDescription = ''
      The goal of ANGLE is to allow users of multiple operating systems
      to seamlessly run WebGL and other OpenGL ES content by translating
      OpenGL ES API calls to one of the hardware-supported APIs available
      for that platform.
    '';
    homepage = "https://angleproject.org";
    maintainers = with lib.maintainers; [
      jess
      jk
    ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
