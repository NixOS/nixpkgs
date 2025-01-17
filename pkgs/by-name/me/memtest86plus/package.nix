{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtest86+";
  version = "7.20";

  src = fetchFromGitHub {
    owner = "memtest86plus";
    repo = "memtest86plus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JZ6feyk66DLKEnugc+yXN4KckQrCTMNqQL4TvCTw1EU=";
  };

  # Binaries are booted directly by BIOS/UEFI or bootloader
  # and should not be patched/stripped
  dontPatchELF = true;
  dontStrip = true;

  passthru.efi = "${finalAttrs.finalPackage}/memtest.efi";

  preBuild = ''
    cd ${if stdenv.hostPlatform.isi686 then "build32" else "build64"}
  '';

  installPhase = ''
    install -Dm0444 -t $out/ memtest.bin memtest.efi
  '';

  meta = {
    homepage = "https://www.memtest.org/";
    description = "Tool to detect memory errors";
    license = lib.licenses.gpl2Only;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ lib.maintainers.LunNova ];
  };
})
