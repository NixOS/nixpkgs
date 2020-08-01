{ mkDerivation
, stdenv
, fetchFromGitHub
, fetchpatch
, installShellFiles
, qmake
, qtbase
, qtmultimedia
, qttools
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsaLib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, jackSupport ? stdenv.hostPlatform.isUnix
, libjack2
}:
let

  inherit (stdenv.lib) optional optionals;

in
mkDerivation rec {
  pname = "bambootracker";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "rerrahkr";
    repo = "BambooTracker";
    rev = "v${version}";
    sha256 = "0gq40qmsdavsyl2d6a71rwp4mjlwvp1c8bry32srn4hliwfnvqa6";
  };

  # Fix macOS build until new release
  patches = [
    (fetchpatch {
      url = "https://github.com/rerrahkr/BambooTracker/commit/45346ed99559d44c2e32a5c6138a0835b212e875.patch";
      sha256 = "1xkiqira1kpcqkacycy0y7qm1brhf89amliv42byijl4palmykh2";
    })
  ];

  preConfigure = "cd BambooTracker";

  nativeBuildInputs = [ qmake qttools installShellFiles ];

  buildInputs = [ qtbase qtmultimedia ]
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optional jackSupport libjack2;

  qmakeFlags = [ "CONFIG+=release" "CONFIG-=debug" ]
    ++ optional pulseSupport "CONFIG+=use_pulse"
    ++ optionals jackSupport [ "CONFIG+=use_jack" "CONFIG+=jack_has_rename" ];

  postInstall = ''
    install -Dm644 ../BambooTracker.desktop $out/share/applications/BambooTracker.desktop
    installManPage ../BambooTracker*.1

    cp -r ../{demos,licenses,skins,LICENSE} $out/share/BambooTracker/

    for size in 16x16 256x256; do
      install -Dm644 res/icon/icon_$size.png $out/share/icons/hicolor/$size/apps/BambooTracker.png
    done
  '';

  meta = with stdenv.lib; {
    description = "A tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    homepage = "https://github.com/rerrahkr/BambooTracker";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
