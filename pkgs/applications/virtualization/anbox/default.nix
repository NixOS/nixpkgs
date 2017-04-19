{ stdenv, fetchurl, fetchpatch, fetchFromGitHub, fetchbzr, cmake, pkgconfig, boost, libxml2, dbus, gtest, gmock
, lcov, SDL2, mesa_glu, protobuf, lxc, glm, xorg, linuxPackages, pythonPackages, bash, coreutils, python2, SDL2_image
, makeWrapper, libglvnd, kernel ? null, systemd }:

let
  properties-cpp = stdenv.mkDerivation rec {
    name = "properties-cpp-${rev}";
    rev = "0.0.1+14.10.20140730-0ubuntu1";
    src = fetchbzr {
      url = "http://bazaar.launchpad.net/~phablet-team/properties-cpp/trunk";
      inherit rev;
      sha256 = "03lf092r71pnvqypv5rg27qczvfbbblrrc3nz6m9mp7j4yfp012w";
    };
    nativeBuildInputs = [ cmake pkgconfig pythonPackages.gcovr lcov ];
    preConfigure = ''
      substituteInPlace CMakeLists.txt --replace 'include(cmake/PrePush.cmake)' "" # skip making .deb
      # Don't build tests
      truncate -s 0 tests/CMakeLists.txt
    '';
  };

  process-cpp = stdenv.mkDerivation rec {
    name = "process-cpp-${version}";
    version = "3.0.1";
    src = fetchurl {
      url = "https://launchpad.net/ubuntu/+archive/primary/+files/process-cpp_${version}.orig.tar.gz";
      sha256 = "0ssap5i0y8qqkzcwh6bg0mybdr4gqg075if9j5vgblwr9qw3vl9k";
    };
    nativeBuildInputs = [ cmake pkgconfig ];
    propagatedBuildInputs = [ boost properties-cpp ];
    buildInputs = [ gtest ];
    cmakeFlags = "-DGMOCK_SOURCE_DIR=${gmock.src}";
    postInstall = ''
      rm -rf $out/include/{gmock,gtest} $out/lib/lib{gmock,gtest}{,_main}.a
    '';
  };

  dbus-cpp = stdenv.mkDerivation rec {
    name = "dbus-cpp-${rev}";
    rev = "5.0.0+18.04.20171031-0ubuntu1";
    src = fetchbzr {
      url = "http://bazaar.launchpad.net/~phablet-team/dbus-cpp/trunk";
      inherit rev;
      sha256 = "1q3k5d5xm3y1k7b5r6jmd0m2kllivz3fxb57qmzzgzf8rab66l8c";
    };
    nativeBuildInputs = [ cmake pkgconfig ];
    propagatedBuildInputs = [ process-cpp libxml2 dbus ];
    buildInputs = [ gtest ];
    preConfigure = ''
      substituteInPlace CMakeLists.txt --replace 'include(cmake/PrePush.cmake)' "" # skip making .deb
      # Don't build tests
      truncate -s 0 tests/CMakeLists.txt
    '';
    cmakeFlags = "-DDBUS_CPP_VERSION_MAJOR=5 -DDBUS_CPP_VERSION_MINOR=0 -DDBUS_CPP_VERSION_PATCH=0 -DGMOCK_SOURCE_DIR=${gmock.src}";
    NIX_CFLAGS_COMPILE = "-Wno-error";
    postInstall = ''
      rm -rf $out/include/{gmock,gtest} $out/lib/lib{gmock,gtest}{,_main}.a $out/libexec
    '';
    patches = [
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/boost-asio-1-66.patch?h=dbus-cpp";
        name = "boost-asio-1-66.patch";
        sha256 = "11byp28rnjnxsxj99jl04my5v5j7fs62r02dcgpdr3ncfc9vqj9b";
      })
    ];
  };

  rev = "69e75c9";
  version = "10.1-unstable-${rev}";
  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox";
    inherit rev;
    sha256 = "151c657iza46v7nr443b0ryqb0vd6nz6yrk17wpb9xwb3y853qk5";
  };
  modules_src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox-modules";
    rev = "5635fc41a23ba415af41f80d12251a74f91ffbb6";
    sha256 = "0gds35svblkrgynii8j5b9mfm5n8r9rq8ddmx38v5z7qlmdnlr6y";
  };
  meta = with stdenv.lib; {
    homepage = "http://anbox.io";
    description = "Container based approach to boot a full Android system";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bkchr ];
  };
in {
  ashmem = stdenv.mkDerivation {
    name = "anbox-ashmem-${version}";
    inherit meta;
    src = modules_src;
    sourceRoot = "source/ashmem";
    hardeningDisable = [ "pic" ];
    makeFlags = "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build DESTDIR=$(out)";
    nativeBuildInputs = kernel.moduleBuildDependencies;
    postInstall = ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra/anbox
      mv $out/ashmem_linux.ko $out/lib/modules/${kernel.modDirVersion}/extra/anbox/ashmem.ko
    '';
  };

  binder = stdenv.mkDerivation {
    name = "anbox-binder-${version}";
    inherit meta;
    src = modules_src;
    sourceRoot = "source/binder";
    hardeningDisable = [ "pic" ];
    makeFlags = "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build DESTDIR=$(out)";
    nativeBuildInputs = kernel.moduleBuildDependencies;
    postInstall = ''
      mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra/anbox
      mv $out/binder_linux.ko $out/lib/modules/${kernel.modDirVersion}/extra/anbox/binder.ko
    '';
  };

  exe = stdenv.mkDerivation {
    name = "anbox-${version}";
    inherit src meta;
  
    nativeBuildInputs = [ cmake pkgconfig ];

    buildInputs = [
      boost SDL2 mesa_glu glm protobuf dbus-cpp lxc
      gtest xorg.libpthreadstubs xorg.libXdmcp SDL2_image
      makeWrapper
    ];

    preConfigure = ''
      # Don't build tests
      truncate -s 0 cmake/FindGMock.cmake
      truncate -s 0 tests/CMakeLists.txt

      substituteInPlace scripts/gen-emugl-entries.py --replace '/usr/bin/env python2' "${python2}/bin/python"
    '';
    cmakeFlags = "-DCMAKE_INSTALL_LIBDIR=lib";
  
    postInstall = ''
      cat > $out/bin/runme <<EOF
      #!${bash}/bin/bash

      $out/bin/anbox session-manager &
      ${coreutils}/bin/sleep 2

      $out/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
      EOF
      chmod +x $out/bin/runme

      wrapProgram "$out/bin/anbox" --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [libglvnd]}
    '';
  };

  anbox-image = fetchurl {
    url = "https://build.anbox.io/android-images/2018/06/12/android_amd64.img";
    sha256 = "5c4b8f7caeaf604770e37a29b65c7711b26d009a548b4fac8dfb77585e56dc73";
  };
}
