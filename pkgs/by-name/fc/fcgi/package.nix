{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcgi";
<<<<<<< HEAD
  version = "2.4.7";
=======
  version = "2.4.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "FastCGI-Archives";
    repo = "fcgi2";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-uMYuVb68zHJgMUdgM/R9QIRCxrQdtVHWA/9IZOdktGc=";
=======
    hash = "sha256-rVurW9zcUT4IFVmrq/kuGuMbv6geQZC+WyAtqtN778Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
