{
  lib,
  buildNimPackage,
  fetchFromGitea,
  raylib,
}:

buildNimPackage (finalAttrs: {
  pname = "snekim";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "snekim";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Qgvq4CkGvNppYFpITCCifOHtVQYRQJPEK3rTJXQkTvI=";
  };

  strictDeps = true;
  lockFile = ./lock.json;

  nimFlags = [ "-d:nimraylib_now_shared" ];

  postInstall = ''
    install -D snekim.desktop -t $out/share/applications
    install -D icons/hicolor/48x48/snekim.svg -t $out/share/icons/hicolor/48x48/apps
  '';

  meta = {
    homepage = "https://codeberg.org/annaaurora/snekim";
    description = "A simple implementation of the classic snake game";
    mainProgram = "snekim";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.annaaurora ];
  };
})
