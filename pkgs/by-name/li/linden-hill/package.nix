{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "linden-hill";
  version = "2011-05-25";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = "linden-hill";
    rev = "a3f7ae6c4cac1b7e5ce5269e1fcc6a2fbb9e31ee";
    hash = "sha256-EjXcLjzVQeOJgLxGua8t0oMc+APOsONGGpG6VJVCgFw=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Digital version of Frederic Goudy’s Deepdene";
    longDescription = ''
      Linden Hill is a digital version of Frederic Goudy’s Deepdene. The
      package includes roman and italic.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/linden-hill";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
