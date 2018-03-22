{ config, stdenv, fetchgit, makeWrapper, gnome3, at-spi2-core, libcxx,
  boost, epoxy, cmake, aspell, llvmPackages, libgit2, pkgconfig, pcre,
  libXdmcp, libxkbcommon, libpthreadstubs, wrapGAppsHook, aspellDicts,
  coreutils, glibc, dbus_libs, openssl, libxml2, gnumake, ctags }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "juicipp-${version}";
  version = "1.2.3";

  meta = {
    homepage = https://github.com/cppit/jucipp;
    description = "A lightweight, platform independent C++-IDE with support for C++11, C++14, and experimental C++17 features depending on libclang version";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xnwdd ];
  };

  src = fetchgit {
    url = "https://github.com/cppit/jucipp.git";
    rev = "refs/tags/v${version}";
    deepClone = true;
    sha256 = "0xp6ijnrggskjrvscp204bmdpz48l5a8nxr9abp17wni6akb5wiq";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [
    dbus_libs
    openssl
    libxml2
    gnome3.gtksourceview
    at-spi2-core
    pcre
    epoxy
    boost
    libXdmcp
    cmake
    aspell
    libgit2
    libxkbcommon
    gnome3.gtkmm3
    libpthreadstubs
    gnome3.gtksourceviewmm
    llvmPackages.clang.cc
    llvmPackages.lldb
    gnome3.dconf
  ];


  lintIncludes = let
    p = "arguments.emplace_back(\"-I";
    e = "\");";
    v = stdenv.lib.getVersion llvmPackages.clang;
  in
    p+llvmPackages.libcxx+"/include/c++/v1"+e
    +p+llvmPackages.clang-unwrapped+"/lib/clang/"+v+"/include/"+e
    +p+glibc.dev+"/include"+e;

  preConfigure = ''
    sed -i 's|liblldb LIBLLDB_LIBRARIES|liblldb LIBNOTHING|g' CMakeLists.txt
    sed -i 's|> arguments;|> arguments; ${lintIncludes}|g' src/source_clang.cc
  '';
  cmakeFlags = "-DLIBLLDB_LIBRARIES=${stdenv.lib.makeLibraryPath [ llvmPackages.lldb ]}/liblldb.so";
  postInstall = ''
    mv $out/bin/juci $out/bin/.juci
    makeWrapper "$out/bin/.juci" "$out/bin/juci" \
      --set PATH "${stdenv.lib.makeBinPath [ ctags coreutils llvmPackages.clang.cc cmake gnumake llvmPackages.clang.bintools llvmPackages.clang ]}" \
      --set NO_AT_BRIDGE 1 \
      --set ASPELL_CONF "dict-dir ${aspellDicts.en}/lib/aspell"
  '';

}
