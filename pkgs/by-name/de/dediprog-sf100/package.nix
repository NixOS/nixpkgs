{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  libusb1,
  pkg-config,
}:

let
  dediprogVersion = "1.14.21,x";
  dediprogHash = "sha256-tz5qLN74IbUcvj2nXzR6Q7Nh9l/LAUy/6h43J+o8dvc=";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dediprog-sf100-linux";
  version = finalAttrs.dediprogVersion;

  inherit dediprogVersion dediprogHash;

  src = fetchFromGitHub {
    owner = "DediProgSW";
    repo = "SF100Linux";
    rev = "V${finalAttrs.dediprogVersion}";
    hash = finalAttrs.dediprogHash;
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  doInstallCheck = true;
  udevRules = pkgs.writeText "dediprog.rules" ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="dada", MODE="660", GROUP="plugdev"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 ./dpcmd -t $out/bin
    install -Dm0644 ./ChipInfoDb.dedicfg -t $out/share/DediProg
    install -Dm0644 ${finalAttrs.udevRules} -D $out/lib/udev/rules.d/60-dediprog.rules

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/DediProgSW/SF100Linux";
    description = "Linux software for DediProg SF100/SF600 programmers";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thillux ];
  };
})
