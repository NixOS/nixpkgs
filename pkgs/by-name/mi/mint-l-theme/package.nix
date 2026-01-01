{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3,
<<<<<<< HEAD
  python3Packages,
}:

stdenvNoCC.mkDerivation {
  pname = "mint-l-theme";
  version = "2.0.5";
=======
  sassc,
  sass,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-theme";
  version = "2.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "mint-l-theme";
<<<<<<< HEAD
    # They don't really do tags, this is just a named commit.
    rev = "112daa4f76ccef08a9c4e3b107957ff862429516";
    hash = "sha256-Y6rPrEG+Gh2V+TbLDTqVgPSYQMBXWKacYrS1FMzmQVo=";
=======
    rev = version;
    hash = "sha256-QPTU/wCOytleuiQAodGzZ1MGWD2Sk7eoeXWpi6nS5As=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    python3
<<<<<<< HEAD
    python3Packages.libsass
=======
    sassc
    sass
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/linuxmint/mint-l-theme";
    description = "Mint-L theme for the Cinnamon desktop";
    license = lib.licenses.gpl3Plus; # from debian/copyright
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
=======
  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-theme";
    description = "Mint-L theme for the Cinnamon desktop";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
