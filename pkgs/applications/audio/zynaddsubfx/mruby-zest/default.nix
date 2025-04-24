{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  pkg-config,
  rake,
  ruby,
  libGL,
  libuv,
  libX11,
  pkgsBuildBuild,
  windows,
  makeStaticLibraries,
}: let
  makeStatic = p: p.override {stdenv = makeStaticLibraries stdenv ;};
in
  (makeStaticLibraries stdenv).mkDerivation rec {
  pname = "mruby-zest";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "${pname}-build";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "sha256-rIb6tQimwrUj+623IU5zDyKNWsNYYBElLQClOsP+5Dc=";
  };

  patches = [
    ./force-cxx-as-linker.patch
    ./0001-use-system-libuv-for-mingw-w64-builds.patch
  ];

  postPatch = ''
    cd mruby
    patch -p1 -N < ../string-backtraces.diff
    cd ..
  '';

  nativeBuildInputs = [
    bison
    pkg-config
    rake
    ruby
    pkgsBuildBuild.stdenv.cc
  ];

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isWindows) [ libuv libGL libX11 ]
  ++ lib.optionals (stdenv.hostPlatform.isMinGW) (map makeStatic [ libuv windows.mingw_w64_pthreads ]);

  # Force optimization to fix:
  # warning: #warning _FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = "-O3";

  # Remove pre-built y.tab.c to generate with nixpkgs bison
  preBuild = ''
    rm mruby/mrbgems/mruby-compiler/core/y.tab.c
  '' +
  lib.optionals stdenv.hostPlatform.isWindows ''
    ruby rebuild-fcache.rb
  '';

  makeFlags = lib.optionals stdenv.hostPlatform.isWindows "windows";

  installTargets = lib.optionals (!stdenv.hostPlatform.isWindows) "pack";

  installPhase = lib.optionals stdenv.hostPlatform.isWindows ''
    mkdir -p $out/bin
    cp {zest.exe,libzest.dll} "$out/bin"

    mkdir -p $out/bin/font
    mkdir -p $out/bin/schema

    cp $(find ./deps/nanovg -type f | grep ttf) $out/bin/font/

    cp ./src/osc-bridge/schema/test.json $out/bin/schema/
    cp -r ./src/mruby-zest/{qml,example} $out/bin
  '';

  postInstall = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    ln -s "$out/zest" "$out/zyn-fusion"
    cp -a package/{font,libzest.so,schema,zest} "$out"
    '' +
    ''
    # mruby-widget-lib/src/api.c requires MainWindow.qml as part of a
    # sanity check, even though qml files are compiled into the binary
    # https://github.com/mruby-zest/mruby-zest-build/blob/3.0.6/src/mruby-widget-lib/src/api.c#L107-L124
    # https://github.com/mruby-zest/mruby-zest-build/blob/3.0.6/linux-pack.sh#L17-L18
    mkdir -p "$out/qml"
    touch "$out/qml/MainWindow.qml"
    '';


  meta = with lib; {
    description = "Zest Framework used in ZynAddSubFX's UI";
    homepage = "https://github.com/mruby-zest";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.all;
  };
}
