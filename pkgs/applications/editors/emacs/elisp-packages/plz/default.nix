{ trivialBuild, lib, fetchFromGitHub, curl }:

trivialBuild {
  pname = "plz";
  version = "unstable-2021-08-22";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "plz.el";
    rev = "7e456638a651bab3a814e3ea81742dd917509cbb";
    sha256 = "sha256-8kn9ax1AVF6f9iCTqvVeJZihs03pYAhLjUDooG/ubxY=";
  };

  postPatch = ''
    substituteInPlace ./plz.el --replace 'plz-curl-program "curl"' 'plz-curl-program "${curl}/bin/curl"'
  '';

  meta = {
    description = "plz is an HTTP library for Emacs";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
