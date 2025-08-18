{
  lib,
  stdenvNoCC,
  fetchfossil,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "durden";
  version = "0-unstable-2025-08-22";

  src = fetchfossil {
    url = "https://chiselapp.com/user/letoram/repository/durden";
    rev = "b880edb269c99ece8ae6dd5713d459036676359d8fe6c3626acaf87aa56e4793";
    hash = "sha256-GwYMgw8NjnoJcXs35UUW8cTI6Zfies+5Q6i+NHIHYPQ=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/
    cp -a ./durden ${placeholder "out"}/share/arcan/appl/

    runHook postInstall
  '';

  meta = {
    homepage = "https://durden.arcan-fe.com/";
    description = "Reference Desktop Environment for Arcan";
    longDescription = ''
      Durden is a desktop environment for the Arcan Display Server. It serves
      both as a reference showcase on how to take advantage of some of the
      features in Arcan, and as a very competent entry to the advanced-user side
      of the desktop environment spectrum.
    '';
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
