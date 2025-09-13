{
  commonMeta,
  multipass_src,
  version,

  cmake,
  dnsmasq,
  fetchFromGitHub,
  fmt,
  git,
  grpc,
  gtest,
  iproute2,
  iptables,
  lib,
  libapparmor,
  libvirt,
  libxml2,
  openssl,
  OVMF,
  pkg-config,
  poco,
  protobuf,
  qemu-utils,
  qemu,
  qt6,
  slang,
  stdenv,
  xterm,
}:

stdenv.mkDerivation {
  inherit version;
  pname = "multipassd";
  src = multipass_src;

  patches = [
    # Multipass is usually only delivered as a snap package on Linux, and it expects that
    # the LXD backend will also be delivered via a snap - in which cases the LXD socket
    # is available at '/var/snap/lxd/...'. Here we patch to ensure that Multipass uses the
    # LXD socket location on NixOS in '/var/lib/...'
    ./lxd_socket_path.patch
    # The upstream cmake file attempts to fetch googletest using FetchContent, which fails
    # in the Nix build environment. This patch disables the fetch in favour of providing
    # the googletest library from nixpkgs.
    ./cmake_no_fetch.patch
    # As of Multipass 1.14.0, the upstream started using vcpkg for grabbing C++ dependencies,
    # which doesn't work in the nix build environment. This patch reverts that change, in favour
    # of providing those dependencies manually in this derivation.
    ./vcpkg_no_install.patch
    # The compiler flags used in nixpkgs surface an error in the test suite where an
    # unreachable path was not annotated as such - this patch adds the annotation to ensure
    # that the test suite passes in the nix build process.
    ./test_unreachable_call.patch
  ];

  postPatch = ''
    # Make sure the version is reported correctly in the compiled binary.
    substituteInPlace ./CMakeLists.txt \
      --replace-fail "determine_version(MULTIPASS_VERSION)" "" \
      --replace-fail 'set(MULTIPASS_VERSION ''${MULTIPASS_VERSION})' 'set(MULTIPASS_VERSION "v${version}")'

    # Don't build the GUI .desktop file, do that in the gui derivation instead
    substituteInPlace ./CMakeLists.txt --replace-fail "add_subdirectory(data)" ""

    # Don't build/use vcpkg
    rm -rf 3rd-party/vcpkg

    # Patch the patch of the OVMF binaries to use paths from the nix store.
    substituteInPlace ./src/platform/backends/qemu/linux/qemu_platform_detail_linux.cpp \
      --replace-fail "OVMF.fd" "${OVMF.fd}/FV/OVMF.fd" \
      --replace-fail "QEMU_EFI.fd" "${OVMF.fd}/FV/QEMU_EFI.fd"

    # Configure CMake to use gtest from the nix store since we disabled fetching from the internet.
    cat >> tests/CMakeLists.txt <<'EOF'
      add_library(gtest INTERFACE)
      target_include_directories(gtest INTERFACE ${gtest.dev}/include)
      target_link_libraries(gtest INTERFACE ${gtest}/lib/libgtest.so ''${CMAKE_THREAD_LIBS_INIT})
      add_dependencies(gtest GMock)

      add_library(gtest_main INTERFACE)
      target_include_directories(gtest_main INTERFACE ${gtest.dev}/include)
      target_link_libraries(gtest_main INTERFACE ${gtest}/lib/libgtest_main.so gtest)

      add_library(gmock INTERFACE)
      target_include_directories(gmock INTERFACE ${gtest.dev}/include)
      target_link_libraries(gmock INTERFACE ${gtest}/lib/libgmock.so gtest)

      add_library(gmock_main INTERFACE)
      target_include_directories(gmock_main INTERFACE ${gtest.dev}/include)
      target_link_libraries(gmock_main INTERFACE ${gtest}/lib/libgmock_main.so gmock gtest_main)
    EOF
  '';

  # We'll build the flutter application separately using buildFlutterApplication
  cmakeFlags = [ "-DMULTIPASS_ENABLE_FLUTTER_GUI=false" ];

  buildInputs = [
    fmt
    grpc
    gtest
    libapparmor
    libvirt
    libxml2
    openssl
    poco.dev
    protobuf
    qt6.qtbase
    qt6.qtwayland
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    qt6.wrapQtAppsHook
    slang
  ];

  nativeCheckInputs = [ gtest ];

  postInstall = ''
    wrapProgram $out/bin/multipassd --prefix PATH : ${
      lib.makeBinPath [
        dnsmasq
        iproute2
        iptables
        OVMF.fd
        qemu
        qemu-utils
        xterm
      ]
    }
  '';

  meta = commonMeta // {
    description = "Backend server & client for managing on-demand Ubuntu VMs";
  };
}
