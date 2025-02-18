{
  lib,
  gawk,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lukesmithxyz-bible-kjv";
  version = "unstable-2022-06-01";

  src = fetchFromGitHub {
    owner = "lukesmithxyz";
    repo = "kjv";
    rev = "1b675c0396806a2a3d134c51fd11d9fed8ea3dc5";
    hash = "sha256-ii5SGZmO99VYbKdebfEbN3rL7LLSSQ0jm5mGqX2G3o0=";
  };

  buildInputs = [ gawk ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Read the Word of God from your terminal + Apocrypha";
    mainProgram = "kjv";
    homepage = "https://lukesmith.xyz/articles/command-line-bibles";
    license = licenses.unlicense;
    platforms = platforms.unix;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
