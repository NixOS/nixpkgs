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
  version = "2.0.0-next.1";

  src = fetchurl {
    url = "https://code.castopod.org/adaures/castopod/uploads/a5f2f66c8c9f8be80c66a7f9a3e831b9/castopod-2.0.0-next.1.tar.gz";
    sha256 = "1ib8kfx90g0qayarn9cazsw1p4zhsnlmwx0y1z0wh22sjfxnhwa6";
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
    description = "Open-source hosting platform made for podcasters who want to engage and interact with their audience";
    homepage = "https://castopod.org";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ alexoundos ];
    platforms = platforms.all;
  };
}
