{ stdenv, fetchFromGitHub, fetchpatch, mkDerivation, SDL2, frei0r, gettext, mlt
, jack1, pkgconfig, qtbase, qtmultimedia, qtwebkit, qtx11extras, qtwebsockets
, qtquickcontrols, qtgraphicaleffects, libmlt, qmake, qttools
}:

assert stdenv.lib.versionAtLeast libmlt.version "6.8.0";
assert stdenv.lib.versionAtLeast mlt.version "6.8.0";

let
  # https://github.com/mltframework/shotcut/issues/771
  fixVaapiRendering1 = fetchpatch {
    url = "https://github.com/peti/shotcut/commit/038f6839298fc1e9e80ddf84fe168a78118bc625.patch";
    sha256 = "153z1g6criszd6gdkw4f5zk0gmh0jar6l2g8fzwjhhcvkdz30vbp";
  };
  fixVaapiRendering2 = fetchpatch {
    url = "https://github.com/peti/shotcut/commit/653c485f92d2847fdac517e3f797c9254826ffab.patch";
    sha256 = "1qd0zgyahda72xh3avlg7lg0jq94wq5847154qlrgzj8b4n7vizw";
  };
in

mkDerivation rec {
  pname = "shotcut";
  version = "19.09.14";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    rev = "v${version}";
    sha256 = "1cl8ba1n0h450r4n5mfqmyjaxvczs3m19blwxslqskvmxy5my3cn";
  };

  patches = [ fixVaapiRendering1 fixVaapiRendering2 ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    SDL2 frei0r gettext mlt libmlt
    qtbase qtmultimedia qtwebkit qtx11extras qtwebsockets qtquickcontrols
    qtgraphicaleffects
  ];

  NIX_CFLAGS_COMPILE = "-I${libmlt}/include/mlt++ -I${libmlt}/include/mlt";
  qmakeFlags = [ "QMAKE_LRELEASE=${stdenv.lib.getDev qttools}/bin/lrelease" "SHOTCUT_VERSION=${version}" ];

  prePatch = ''
    sed 's_shotcutPath, "qmelt"_"${mlt}/bin/melt"_' -i src/jobs/meltjob.cpp
    sed 's_shotcutPath, "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/jobs/ffmpegjob.cpp
    sed 's_qApp->applicationDirPath(), "ffmpeg"_"${mlt.ffmpeg}/bin/ffmpeg"_' -i src/docks/encodedock.cpp
    NICE=$(type -P nice)
    sed "s_/usr/bin/nice_''${NICE}_" -i src/jobs/meltjob.cpp src/jobs/ffmpegjob.cpp
  '';

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [jack1 SDL2]}"
    "--prefix PATH : ${mlt}/bin"
    ];

  postInstall = ''
    mkdir -p $out/share/shotcut
    cp -r src/qml $out/share/shotcut/
  '';

  meta = with stdenv.lib; {
    description = "A free, open source, cross-platform video editor";
    longDescription = ''
      An official binary for Shotcut, which includes all the
      dependencies pinned to specific versions, is provided on
      http://shotcut.org.

      If you encounter problems with this version, please contact the
      nixpkgs maintainer(s). If you wish to report any bugs upstream,
      please use the official build from shotcut.org instead.
    '';
    homepage = https://shotcut.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu woffs ];
    platforms = platforms.linux;
  };
}
