{ trivialBuild, lib, fetchFromGitHub, curl }:

trivialBuild {
  pname = "plz";
  version = "0.pre+date=2021-08-22";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "plz.el";
    rev = "7e456638a651bab3a814e3ea81742dd917509cbb";
    hash = "sha256-8kn9ax1AVF6f9iCTqvVeJZihs03pYAhLjUDooG/ubxY=";
  };

  postPatch = ''
    substituteInPlace ./plz.el \
      --replace 'plz-curl-program "curl"' 'plz-curl-program "${curl}/bin/curl"'
  '';

  meta = {
    description = "An HTTP library for Emacs";
    longDescription = ''
      plz is an HTTP library for Emacs. It uses curl as a backend, which avoids
      some of the issues with using Emacs’s built-in url library. It supports
      both synchronous and asynchronous requests. Its API is intended to be
      simple, natural, and expressive. Its code is intended to be simple and
      well-organized. Every feature is tested against httpbin.org.
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
