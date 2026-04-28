{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
  libarchive,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      cheetah3
      lxml
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sickgear";
  version = "3.35.3";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-8nkkU9YJOpj6yaS0Xu3/7DCQR2FfU6VQhVwys6i42q0=";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    pythonEnv
    libarchive
  ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/sickgear
    cp -R {autoProcessTV,gui,lib,sickgear,sickgear.py} $out/opt/sickgear/

    makeWrapper $out/opt/sickgear/sickgear.py $out/bin/sickgear \
      --suffix PATH : ${lib.makeBinPath [ libarchive ]}
  '';

  meta = {
    description = "Most reliable stable TV fork of the great Sick-Beard to fully automate TV enjoyment with innovation";
    mainProgram = "sickgear";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/SickGear/SickGear";
    maintainers = with lib.maintainers; [ rembo10 ];
  };
})
