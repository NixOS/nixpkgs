{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-Exrps3DicL/G/g0kbSsCvoFhiJn1k3v8I09GhW7EwNM=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "Wallpapers for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-wallpapers";
    license = with licenses; [ cc-by-40 publicDomain ];
    platforms = platforms.all;

    maintainers = with maintainers; [
      pandapip1
      thefossguy
    ];
  };
}
