{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
  sassc,
  sass,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-theme";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-Jql4NJ8jugy0wi5yT+/Mr5fwxLog37w0VvHhxyMvMlk=";
  };

  nativeBuildInputs = [
    python3
    sassc
    sass
  ];

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-theme";
    description = "Mint-L theme for the Cinnamon desktop";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
