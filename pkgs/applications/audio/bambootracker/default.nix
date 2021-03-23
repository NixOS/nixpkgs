{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, fetchpatch
, qmake
, pkg-config
, qttools
, qtbase
, rtaudio
, rtmidi
}:

mkDerivation rec {
  pname = "bambootracker";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rerrahkr";
    repo = "BambooTracker";
    rev = "v${version}";
    sha256 = "0iddqfw951dw9xpl4w7310sl4z544507ppb12i8g4fzvlxfw2ifc";
  };

  # TODO Remove when updating past 0.4.6
  # Fixes build failure on darwin
  patches = [
    (fetchpatch {
      name = "bambootracker-Add_braces_in_initialization_of_std-array.patch";
      url = "https://github.com/rerrahkr/BambooTracker/commit/0fc96c60c7ae6c2504ee696bb7dec979ac19717d.patch";
      sha256 = "1z28af46mqrgnyrr4i8883gp3wablkk8rijnj0jvpq01s4m2sfjn";
    })
  ];

  nativeBuildInputs = [ qmake qttools pkg-config ];

  buildInputs = [ qtbase rtaudio rtmidi ];

  qmakeFlags = [ "CONFIG+=system_rtaudio" "CONFIG+=system_rtmidi" ];

  postConfigure = "make qmake_all";

  # installs app bundle on darwin, re-extract the binary
  # wrapQtAppsHook fails to wrap mach-o binaries, manually call wrapper (https://github.com/NixOS/nixpkgs/issues/102044)
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $out/bin/BambooTracker{.app/Contents/MacOS/BambooTracker,}
    rm -r $out/bin/BambooTracker.app
    wrapQtApp $out/bin/BambooTracker
  '';

  meta = with lib; {
    description = "A tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    homepage = "https://rerrahkr.github.io/BambooTracker";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
