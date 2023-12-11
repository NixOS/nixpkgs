{ stdenv
, fetchurl
, ffmpeg-headless
, lib
, nixosTests
, stateDirectory ? "/var/lib/castopod"
}:
stdenv.mkDerivation {
  pname = "castopod";
  version = "1.7.1";

  src = fetchurl {
    url = "https://code.castopod.org/adaures/castopod/uploads/2c93d47db7067fd0f9740430dc74cf7a/castopod-1.7.1.tar.gz";
    sha256 = "0gvlnnc164lp51crd8b254n8681gf508mh6i0mmwzhbskhn1k9y2";
  };

  dontBuild = true;
  dontFixup = true;

  postPatch = ''
    # not configurable at runtime unfortunately:
    substituteInPlace app/Config/Paths.php \
      --replace "__DIR__ . '/../../writable'" "'${stateDirectory}/writable'"

    # configuration file must be writable, place it to ${stateDirectory}
    substituteInPlace modules/Install/Controllers/InstallController.php \
      --replace "ROOTPATH" "'${stateDirectory}/'"
    substituteInPlace public/index.php spark \
      --replace "DotEnv(ROOTPATH)" "DotEnv('${stateDirectory}')"

    # ffmpeg is required for Video Clips feature
    substituteInPlace modules/MediaClipper/VideoClipper.php \
      --replace "ffmpeg" "${ffmpeg-headless}/bin/ffmpeg"
    substituteInPlace modules/Admin/Controllers/VideoClipsController.php \
      --replace "which ffmpeg" "echo ${ffmpeg-headless}/bin/ffmpeg"
  '';

  installPhase = ''
    mkdir -p $out/share/castopod
    cp -r . $out/share/castopod
  '';

  passthru.tests.castopod = nixosTests.castopod;
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "An open-source hosting platform made for podcasters who want to engage and interact with their audience";
    homepage = "https://castopod.org";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ alexoundos misuzu ];
    platforms = platforms.all;
  };
}
