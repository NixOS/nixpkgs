{ stdenv
, fetchurl
, ffmpeg-headless
, lib
, nixosTests
, stateDirectory ? "/var/lib/castopod"
}:
stdenv.mkDerivation {
  pname = "castopod";
  version = "1.6.5";

  src = fetchurl {
    url = "https://code.castopod.org/adaures/castopod/uploads/5aaaa6cf2edaed25bd7253449e5f8584/castopod-1.6.5.tar.gz";
    sha256 = "04gcq2vmfy5aa2fmsm1qqv1k8g024nikmysdrhy33wj460d529b5";
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
