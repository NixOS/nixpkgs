{ lib, stdenv, fetchFromGitHub, cmake, git, pkg-config, python3
, cairo, libsndfile, libxcb, libxkbcommon, xcbutil, xcbutilcursor, xcbutilkeysyms, zenity
}:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    rev = "release_${version}";
    sha256 = "0lla860g7zgn9n1zgy14g4j72d5n5y7isyxz2w5xy2fzdpdg24ql";
    leaveDotGit = true; # for SURGE_VERSION
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git pkg-config python3 ];
  buildInputs = [ cairo libsndfile libxcb libxkbcommon xcbutil xcbutilcursor xcbutilkeysyms zenity ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    substituteInPlace vstgui.surge/vstgui/lib/platform/linux/x11fileselector.cpp --replace /usr/bin/zenity ${zenity}/bin/zenity
    patchShebangs scripts/linux/emit-vector-piggy
    patchShebangs scripts/linux/generate-lv2-ttl
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/share/surge
    cp -r surge_products/Surge.lv2 $out/lib/lv2/
    cp -r surge_products/Surge.vst3 $out/lib/vst3/
    cp -r ../resources/data/* $out/share/surge/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    cd ..
    build/surge-headless
  '';

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
