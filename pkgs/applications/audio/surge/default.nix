{ stdenv, fetchFromGitHub, premake5, pkgconfig, cmake
,cairo, libxkbcommon, libxcb, xcb-util-cursor, xcbutilkeysyms, ncurses, which, getopt
,python, gnome3, lato }:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    rev = "release_${version}";
    sha256 = "0al021f516ybhnp3lhqx8i6c6hpfaw3gqfwwxx3lx3hh4b8kjfjw";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ premake5 pkgconfig cmake ncurses which getopt python ];

  buildInputs = [  cairo libxkbcommon libxcb xcb-util-cursor xcbutilkeysyms gnome3.zenity lato ];

  buildFlags = [ "config=release_x64" ];

  enableParallelBuilding = true;

  patchPhase = ''
    patchShebangs build-linux.sh
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace 'execlp("zenity"' 'execlp("${gnome3.zenity}/bin/zenity"'
    substituteInPlace src/common/gui/PopupEditorDialog.cpp --replace zenity ${gnome3.zenity}/bin/zenity
  '';

  configurePhase = ''
      ./build-linux.sh premake
      python scripts/linux/emit-vector-piggy.py .
    '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r target/lv2/Release/Surge.lv2/ $out/lib/lv2
    mkdir -p $out/lib/vst
    cp target/vst3/Release/Surge.so $out/lib/vst
    mkdir -p $out/share/surge
    cp -r resources/data/* $out/share/surge/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    ./build-linux.sh build -p headless
    ./target/headless/Release/Surge/Surge-Headless
  '';

  meta = with stdenv.lib; {
    description = "LV2 & VST Synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
