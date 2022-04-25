{ lib, stdenv
, fetchFromGitHub
, bison
, git
, libGL
, libX11
, libuv
, pkg-config
, python3
, rake
, ruby
}:

stdenv.mkDerivation rec {
  pname = "mruby-zest";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "${pname}-build";
    rev = version;
    hash = "sha256-rIb6tQimwrUj+623IU5zDyKNWsNYYBElLQClOsP+5Dc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ bison git pkg-config python3 rake ruby ];
  buildInputs = [ libGL libuv libX11 ];

  patches = [
    ./force-gcc-as-linker.patch
  ];

  installTargets = [ "pack" ];

  postInstall = ''
    ln -s "$out/zest" "$out/zyn-fusion"
    cp -a package/{font,libzest.so,schema,zest} "$out"

    # mruby-widget-lib/src/api.c requires MainWindow.qml as part of a
    # sanity check, even though qml files are compiled into the binary
    # https://github.com/mruby-zest/mruby-zest-build/tree/3.0.5/src/mruby-widget-lib/src/api.c#L99-L116
    # https://github.com/mruby-zest/mruby-zest-build/tree/3.0.5/linux-pack.sh#L17-L18
    mkdir -p "$out/qml"
    touch "$out/qml/MainWindow.qml"
  '';

  meta = with lib; {
    description = "The Zest Framework used in ZynAddSubFX's UI";
    homepage = "https://github.com/mruby-zest";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.all;
  };
}
