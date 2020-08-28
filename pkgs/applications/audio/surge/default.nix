{ stdenv, fetchFromGitHub, premake5, pkgconfig, cmake
,cairo, libxkbcommon, libxcb, xcb-util-cursor, xcbutilkeysyms, ncurses, which, getopt
,python, gnome3, lato, pcre, libpthreadstubs, libXdmcp, xcbutilrenderutil, xcbutilimage, libsndfile }:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    rev = "release_${version}";
    sha256 = "1jhk8iaqh89dnci4446b47315v2lc8gclraygk8m9jl20zpjxl0l";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ premake5 pkgconfig cmake ncurses which getopt python ];

  buildInputs = [  cairo libxkbcommon libxcb xcb-util-cursor xcbutilkeysyms gnome3.zenity lato pcre libpthreadstubs libXdmcp xcbutilrenderutil xcbutilimage libsndfile ];

  buildFlags = [ "config=release_x64" ];

  enableParallelBuilding = true;

  patchPhase = ''
    patchShebangs build-linux.sh
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace 'execlp("zenity"' 'execlp("${gnome3.zenity}/bin/zenity"'
    substituteInPlace src/common/gui/PopupEditorDialog.cpp --replace zenity ${gnome3.zenity}/bin/zenity
  '';

  buildPhase = ''
    ./build-linux.sh build;
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r buildlin/surge_products/Surge.lv2/ $out/lib/lv2
    mkdir -p $out/lib/vst3
    cp -r buildlin/surge_products/Surge.vst3/ $out/lib/vst3
    mkdir -p $out/share/surge
    cp -r resources/data/* $out/share/surge/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    ./build-linux.sh build -p headless
    ./buildlin/surge-headless
  '';

  meta = with stdenv.lib; {
    description = "LV2 & VST Synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
