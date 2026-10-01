{
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "kasmweb";
  version = "1.18.1";
  build = "d09dbc";

  src = fetchzip {
    url = "https://kasm-static-content.s3.amazonaws.com/kasm_release_${version}.${build}.tar.gz";
    sha256 = "sha256-/PPc9tdf47DHKdZDcPDy7D6upbLaIKYIYQXqyVDPZkc=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    rm bin/utils/yq*
    cp -r bin conf www $out/

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.kasmweb.com/";
    description = "Streaming containerized apps and desktops to end-users";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ s1341 ];
  };
}
