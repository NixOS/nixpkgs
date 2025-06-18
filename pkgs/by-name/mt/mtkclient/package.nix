{
  lib,
  fetchFromGitHub,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtkclient";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "${finalAttrs.version}";
    hash = "sha256-cEw+aaJcATtYnu+30usQv0JdTr1EiidrgwYSR49Bw5c=";
  };

  strictDeps = true;

  buildInputs = [ finalAttrs.python ];

  python = python3.withPackages (
    ps: with ps; [
      capstone
      colorama
      flake8
      fusepy
      keystone-engine
      mock
      pycryptodome
      pycryptodomex
      pyserial
      pyside6
      pyusb
      setuptools
      shiboken6
      unicorn
      wheel
    ]
  );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -a . $out
    ln -s $out/mtk.py $out/bin/mtk
    ln -s $out/mtk_gui.py $out/bin/mtk_gui

    runHook postInstall
  '';

  meta = {
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    maintainers = with lib.maintainers; [ kintrix ];
    license = lib.licenses.gpl3Only;
    mainProgram = "mtk";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
