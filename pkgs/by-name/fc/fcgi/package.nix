{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcgi";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "FastCGI-Archives";
    repo = "fcgi2";
    rev = finalAttrs.version;
    hash = "sha256-uMYuVb68zHJgMUdgM/R9QIRCxrQdtVHWA/9IZOdktGc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = "ln -s . $out/include/fastcgi";

  meta = {
    description = "Language independent, scalable, open extension to CGI";
    homepage = "https://fastcgi-archives.github.io/"; # Formerly http://www.fastcgi.com/
    license = lib.licenses.oml;
    mainProgram = "cgi-fcgi";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jtbx ];
  };
})
