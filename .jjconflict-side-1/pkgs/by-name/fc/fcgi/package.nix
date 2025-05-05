{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcgi";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "FastCGI-Archives";
    repo = "fcgi2";
    rev = finalAttrs.version;
    hash = "sha256-DsL44onRIUnf99Y+hTjMOaEVp6cjbdqksm4V+1od6pU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = "ln -s . $out/include/fastcgi";

  meta = {
    description = "Language independent, scalable, open extension to CGI";
    homepage = "https://fastcgi-archives.github.io/"; # Formerly http://www.fastcgi.com/
    license = "FastCGI, see LICENSE.TERMS";
    mainProgram = "cgi-fcgi";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jtbx ];
  };
})
