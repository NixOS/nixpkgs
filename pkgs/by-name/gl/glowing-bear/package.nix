{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glowing-bear";
  version = "0.9.0";

  src = fetchFromGitHub {
    rev = finalAttrs.version;
    owner = "glowing-bear";
    repo = "glowing-bear";
    hash = "sha256-WsBv9qUllotAPPhwThGAiqYUdarA9aY1fpRnU8WRwFE=";
  };

  installPhase = ''
    mkdir $out
    cp index.html serviceworker.js webapp.manifest.json $out
    cp -R 3rdparty assets css directives js $out
  '';

  meta = {
    description = "Web client for Weechat";
    homepage = "https://github.com/glowing-bear/glowing-bear";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
