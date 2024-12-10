{
  stdenv,
  fetchurl,
  ffmpeg-headless,
  lib,
  nixosTests,
  dataDir ? "/var/lib/castopod",
}:
stdenv.mkDerivation {
  pname = "castopod";
  version = "1.10.5";

  src = fetchurl {
    url = "https://code.castopod.org/adaures/castopod/uploads/66de724407be8f940af5eb1d633fbbc3/castopod-1.10.5.tar.gz";
    sha256 = "0ssdgqxqldg2f6ni54k5vlndnjjy9lah47q1crpz5nnkkjgvc96y";
  };

  dontBuild = true;
  dontFixup = true;

  postPatch = ''
    # not configurable at runtime unfortunately:
    substituteInPlace app/Config/Paths.php \
      --replace "__DIR__ . '/../../writable'" "'${dataDir}/writable'"

    substituteInPlace modules/Admin/Controllers/DashboardController.php \
      --replace "disk_total_space('./')" "disk_total_space('${dataDir}')"

    # configuration file must be writable, place it to ${dataDir}
    substituteInPlace modules/Install/Controllers/InstallController.php \
      --replace "ROOTPATH" "'${dataDir}/'"
    substituteInPlace public/index.php spark \
      --replace "DotEnv(ROOTPATH)" "DotEnv('${dataDir}')"

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
    maintainers = with maintainers; [ alexoundos ];
    platforms = platforms.all;
  };
}
