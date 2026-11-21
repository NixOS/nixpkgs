{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnutar,
  xz,
  gptfdisk,
  util-linux,
  exfatprogs,
  dosfstools,
  gnugrep,
  gnused,
  rsync,
  e2fsprogs,
  ntfs3g,
  nix-update-script,
}:

let
  runtimeDeps = [
    bash
    coreutils
    gnutar
    xz
    gptfdisk
    util-linux
    exfatprogs
    dosfstools
    gnugrep
    gnused
    rsync
    e2fsprogs
    ntfs3g
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "multios-usb";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "Mexit";
    repo = "MultiOS-USB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iUlb7mb98rDqgIVcUJGgxUIpAeSQ90pVhukIYUc0P0Q=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash ];

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Boot operating systems directly from ISO/WIM images";
    homepage = "https://github.com/Mexit/MultiOS-USB";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    platforms = lib.platforms.linux;
    mainProgram = "multios-usb";
  };
})
