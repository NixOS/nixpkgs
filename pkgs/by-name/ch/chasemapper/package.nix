{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  bash,
}:
let
  customPython = python3.withPackages (
    ps: with ps; [
      eccodes
      cusfpredict
      flask
      flask-socketio
      lxml
      numpy
      python-dateutil
      pytz
      requests
      pyserial
      simple-websocket
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chasemapper";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "projecthorus";
    repo = "chasemapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KamXFMwozCQnH4zQRqsxq28Jr1NEjDL/Jimy/XEP0Bs=";
  };

  postPatch = ''
    substituteInPlace horusmapper.py \
      --replace-fail '#!/usr/bin/env python2.7' '#!${customPython}/bin/python3'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r chasemapper $out/
    cp -r static $out/
    cp -r templates $out/
    install horusmapper.py $out/
    echo "#!${bash}/bin/bash" > $out/bin/chasemapper
    echo $out/horusmapper.py '"$@"' >> $out/bin/chasemapper
    chmod +x $out/bin/chasemapper

    runHook postInstall
  '';

  meta = {
    description = "Browser-based HAB chase map";
    homepage = "https://github.com/projecthorus/chasemapper";
    changelog = "https://github.com/projecthorus/chasemapper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "chasemapper";
    maintainers = with lib.maintainers; [ scd31 ];
  };
})
