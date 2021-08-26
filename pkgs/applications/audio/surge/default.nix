{ stdenv, lib, fetchurl, fetchFromGitHub, cmake, git, pkg-config, python3
, cairo, libsndfile, libxcb, libxkbcommon, xcbutil, xcbutilcursor, xcbutilkeysyms, zenity
, curl, rsync
}:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "1.9.0";

  src = fetchurl {
    url = "https://github.com/surge-synthesizer/releases/releases/download/${version}/SurgeSrc_${version}.tgz";
    sha256 = "00af4lfcipl0rn0dn4gfipx7nbk8ym1mrmji8v0ar98frsrpxg4k";
  };

  extraContent = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge-extra-content";
    # rev from: https://github.com/surge-synthesizer/surge/blob/release_1.8.1/cmake/stage-extra-content.cmake#L6
    # or: https://github.com/surge-synthesizer/surge/blob/main/cmake/stage-extra-content.cmake
    # SURGE_EXTRA_CONTENT_HASH
    rev = "afc591cc06d9adc3dc8dc515a55c66873fa10296";
    sha256 = "1wqv86l70nwlrb10n47rib80f47a96j9qqg8w5dv46ys1sq2nz7z";
  };
  nativeBuildInputs = [ cmake git pkg-config python3 ];
  buildInputs = [ cairo libsndfile libxcb libxkbcommon xcbutil xcbutilcursor xcbutilkeysyms zenity curl rsync ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    patchShebangs scripts/linux/
    cp -r $extraContent/Skins/ resources/data/skins
  '';


  installPhase = ''
    cd ..
    cmake --build build --config Release --target install-everything-global
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$(mktemp -d)
    export SURGE_DISABLE_NETWORK_TESTS=TRUE
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
