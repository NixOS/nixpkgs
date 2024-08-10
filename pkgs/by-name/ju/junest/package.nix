{ lib, fetchFromGitHub, stdenvNoCC, wget }:

stdenvNoCC.mkDerivation rec {
  pname = "junest";
  version = "7.4.9";

  src = fetchFromGitHub {
    owner = "fsquillace";
    repo = "junest";
    rev = "refs/tags/${version}";
    hash = "sha256-iPZN4zPHRsOh5GjRUbeEQj7BYO2Ng93mNn8TvxpDN3Q=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r $src/bin/ $out/
    cp -r $src/lib/ $out/
    substituteInPlace $out/lib/core/common.sh --replace-fail "wget" ${lib.getExe wget}
  '';

  meta = {
    description = "Arch distro that runs on top of another without root";
    homepage = "https://github.com/fsquillace/junest";
    license = lib.licenses.gpl3Only;
    mainProgram = "junest";
    maintainers = with lib.maintainers; [ jdev082 ];
    platforms = lib.platforms.linux;
  };
}

