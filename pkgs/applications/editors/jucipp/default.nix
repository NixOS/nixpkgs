{ lib, stdenv, fetchgit, dconf, gtksourceview3, at-spi2-core, gtksourceviewmm,
  boost, libepoxy, cmake, aspell, llvmPackages, libgit2, pkg-config, pcre,
  libXdmcp, libxkbcommon, libpthreadstubs, wrapGAppsHook, aspellDicts, gtkmm3,
  coreutils, glibc, dbus, openssl, libxml2, gnumake, ctags }:

with lib;

stdenv.mkDerivation rec {
  pname = "juicipp";
  version = "1.4.4";

  meta = {
    homepage = "https://github.com/cppit/jucipp";
    description = "A lightweight, platform independent C++-IDE with support for C++11, C++14, and experimental C++17 features depending on libclang version";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xnwdd ];
    # error: token ""1.1"" is not valid in preprocessor expression
    # TODO: fix pname being different from the attribute name
    broken = true;
  };

  src = fetchgit {
    url = "https://github.com/cppit/jucipp.git";
    rev = "refs/tags/v${version}";
    deepClone = true;
    sha256 = "sha256-gjYpv5Qt3KLZmw5YfS4IjSQFRMYXoF3ZU5o4IE4tf8w=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook cmake ];
  buildInputs = [
    dbus
    openssl
    libxml2
    gtksourceview3
    at-spi2-core
    pcre
    libepoxy
    boost
    libXdmcp
    aspell
    libgit2
    libxkbcommon
    gtkmm3
    libpthreadstubs
    gtksourceviewmm
    llvmPackages.clang.cc
    llvmPackages.lldb
    dconf
  ];


  lintIncludes = let
    p = "arguments.emplace_back(\"-I";
    e = "\");";
    v = lib.getVersion llvmPackages.clang;
  in
    p+llvmPackages.libcxx.dev+"/include/c++/v1"+e
    +p+llvmPackages.clang-unwrapped.lib+"/lib/clang/"+v+"/include/"+e
    +p+glibc.dev+"/include"+e;

  preConfigure = ''
    sed -i 's|liblldb LIBLLDB_LIBRARIES|liblldb LIBNOTHING|g' CMakeLists.txt
    sed -i 's|> arguments;|> arguments; ${lintIncludes}|g' src/source_clang.cc
  '';
  cmakeFlags = [ "-DLIBLLDB_LIBRARIES=${lib.makeLibraryPath [ llvmPackages.lldb ]}/liblldb.so" ];
  postInstall = ''
    mv $out/bin/juci $out/bin/.juci
    makeWrapper "$out/bin/.juci" "$out/bin/juci" \
      --set PATH "${lib.makeBinPath [ ctags coreutils llvmPackages.clang.cc cmake gnumake llvmPackages.clang.bintools llvmPackages.clang ]}" \
      --set NO_AT_BRIDGE 1 \
      --set ASPELL_CONF "dict-dir ${aspellDicts.en}/lib/aspell"
  '';

}
