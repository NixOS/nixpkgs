{ lib, stdenv, fetchFromGitHub, curses, fetchpatch }:

stdenv.mkDerivation (finalAttrs: {
  pname = "stag";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "seenaburns";
    repo = "stag";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O3iHTsaFs1l9sQV7hOoh4F+w3t28JCNlwT33zBmUP/s=";
  };

  patches = [
    # fix compilation on aarch64 https://github.com/seenaburns/stag/pull/19
    (fetchpatch {
      url = "https://github.com/seenaburns/stag/commit/0a5a8533d0027b2ee38d109adb0cb7d65d171497.diff";
      hash = "sha256-fqcsStduL3qfsp5wLJ0GLfEz0JRnOqsvpXB4gdWwVzg=";
    })
  ];

  buildInputs = [ curses ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    homepage = "https://github.com/seenaburns/stag";
    description = "Terminal streaming bar graph passed through stdin";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
})
