{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnutar,
  xz,
  bzip2,
  gptfdisk,
  util-linux,
  exfatprogs,
  dosfstools,
}:

let
  runtimeDeps = [
    bash
    coreutils
    gnutar
    xz
    bzip2
    gptfdisk
    util-linux
    exfatprogs
    dosfstools
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "multios-usb";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Mexit";
    repo = "MultiOS-USB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QlXyfFXtOM/TnqyTfCK8JOcjcchpPwfGijziQtOMkTM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/multios-usb $out/bin
    cp -r . $out/share/multios-usb
    chmod +x $out/share/multios-usb/multios-usb.sh

    makeWrapper $out/share/multios-usb/multios-usb.sh $out/bin/multios-usb \
      --chdir $out/share/multios-usb \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}

    runHook postInstall
  '';

  meta = {
    description = "Boot operating systems directly from ISO/WIM images";
    homepage = "https://github.com/Mexit/MultiOS-USB";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = with lib.platforms; linux ++ darwin;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "multios-usb";
  };
})
