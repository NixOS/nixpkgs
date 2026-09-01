{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "banner";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "pronovic";
    repo = "banner";
    rev = "BANNER_V${finalAttrs.version}";
    sha256 = "sha256-g9i460W0SanW2xIfZk9Am/vDsRlL7oxJOUhksa+I8zY=";
  };

  meta = {
    homepage = "https://github.com/pronovic/banner";
    description = "Print large banners to ASCII terminals";
    mainProgram = "banner";
    license = lib.licenses.gpl2Only;

    longDescription = ''
      An implementation of the traditional Unix-program used to display
      large characters.
    '';

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
