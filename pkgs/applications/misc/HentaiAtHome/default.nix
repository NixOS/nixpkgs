{ buildGraalvmNativeImage, fetchzip, graalvm17-ce, lib }:

buildGraalvmNativeImage rec {
  pname = "HentaiAtHome";
  version = "1.6.1";
  src = fetchzip {
    url = "https://repo.e-hentai.org/hath/HentaiAtHome_${version}.zip";
    hash =
      "sha512-nGGCuVovj4NJGrihKKYXnh0Ic9YD36o7r6wv9zSivZn22zm8lBYVXP85LnOw2z9DiJARivOctQGl48YFD7vxOQ==";
    stripRoot = false;
  };

  jar = "${src}/HentaiAtHome.jar";
  dontUnpack = true;

  graalvmDrv = graalvm17-ce;
  extraNativeImageBuildArgs = [
    "--enable-url-protocols=http,https"
    "--install-exit-handlers"
    "--no-fallback"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    pushd $(mktemp -d)
    $out/bin/HentaiAtHome
    popd
  '';

  meta = with lib; {
    homepage = "https://ehwiki.org/wiki/Hentai@Home";
    description =
      "Hentai@Home is an open-source P2P gallery distribution system which reduces the load on the E-Hentai Galleries";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terrorjack ];
  };
}
