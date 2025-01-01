{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
}:

stdenvNoCC.mkDerivation {
  pname = "open-sans";
  version = "1.11";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "fonts-team";
    repo = "fonts-open-sans";
    rev = "debian/1.11-1";
    hash = "sha256-gkq5RPa83dND91q1hiA9Qokq1iA8gLQ8XvCNWe+e8Bw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open Sans fonts";
    longDescription = ''
      Open Sans is a humanist sans serif typeface designed by Steve Matteson,
      Type Director of Ascender Corp.
    '';
    homepage = "https://www.opensans.com";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };
}
