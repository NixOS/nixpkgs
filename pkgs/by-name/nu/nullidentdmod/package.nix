{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nullidentdmod";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Ranthrall";
    repo = "nullidentdmod";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E6yAG16HvnyXZ8vaMYTMTs0iGBWaFpgPqIa16G+pHKo=";
  };

  installPhase = ''
    mkdir -p $out/bin

    install -Dm755 nullidentdmod $out/bin
  '';

  meta = {
    description = "Simple identd that just replies with a random string or customized userid";
    mainProgram = "nullidentdmod";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/Ranthrall/nullidentdmod";
    maintainers = [ ];
    platforms = lib.platforms.linux; # Must be run by systemd
  };
})
