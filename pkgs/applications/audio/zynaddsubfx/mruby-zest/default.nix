{ lib
, stdenv
, fetchFromGitHub
, bison
, pkg-config
, rake
, ruby
, libGL
, libuv
, libX11
}:

stdenv.mkDerivation rec {
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
  ];

  nativeBuildInputs = [
    bison
    pkg-config
    rake
    ruby
  ];

  buildInputs = [
    libGL
    libuv
    libX11
  ];

  # Force optimization to fix:
  # warning: #warning _FORTIFY_SOURCE requires compiling with optimization (-O)
  NIX_CFLAGS_COMPILE = "-O3";

  # Remove pre-built y.tab.c to generate with nixpkgs bison
  preBuild = ''
    rm mruby/mrbgems/mruby-compiler/core/y.tab.c
  '';

  installTargets = [ "pack" ];

  postInstall = ''
    ln -s "$out/zest" "$out/zyn-fusion"
    cp -a package/{font,libzest.so,schema,zest} "$out"

    # mruby-widget-lib/src/api.c requires MainWindow.qml as part of a
    # sanity check, even though qml files are compiled into the binary
    # https://github.com/mruby-zest/mruby-zest-build/blob/3.0.6/src/mruby-widget-lib/src/api.c#L107-L124
    # https://github.com/mruby-zest/mruby-zest-build/blob/3.0.6/linux-pack.sh#L17-L18
    mkdir -p "$out/qml"
    touch "$out/qml/MainWindow.qml"
  '';

  meta = with lib; {
    description = "The Zest Framework used in ZynAddSubFX's UI";
    homepage = "https://github.com/mruby-zest";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.all;
  };
}
