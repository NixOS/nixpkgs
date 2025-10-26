{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  fetchurl,
}:

let
  fhs = buildFHSEnv {
    name = "fhs-shell";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "c2000-cgt";
  version = "22.6.1.LTS";

  src = fetchurl {
    url = "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-xqxJ05PLfM/${finalAttrs.version}/ti_cgt_c2000_${finalAttrs.version}_linux-x64_installer.bin";
    hash = "sha256-h+exdlyD7Bj3LZTDVME8jHesInaUUUUmFiIKJR+rM9o=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p /build/
    cp -a $src /build/installer.bin

    chmod +x /build/installer.bin
    ${fhs}/bin/fhs-shell -c '/build/installer.bin --mode unattended --prefix /build/ti'
    mv /build/ti/ti-cgt-c2000_${finalAttrs.version} $out

    runHook postInstall
  '';

  meta = {
    description = "C28x/CLA code generation tools (CGT) - compiler";
    longDescription = ''
      The TI C28x code generation tools (C2000-CGT) facilitate the development of applications
      for TI C28x microcontroller platforms. The platforms include the Concerto (F28M3xx),
      Piccolo (280xx), Delfino floating-point (283xx), and C28x fixed-point (2823x/280x/281x) device families.
    '';
    homepage = "https://www.ti.com/tool/C2000-CGT";
    changelog = "https://software-dl.ti.com/codegen/esd/cgt_public_sw/C2000/${finalAttrs.version}/README.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ teczito ];
    mainProgram = "cl2000";
    platforms = [ "x86_64-linux" ];
  };
})
