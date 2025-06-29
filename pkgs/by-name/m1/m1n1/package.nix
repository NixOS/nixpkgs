{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  source-code-pro,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "m1n1";
  version = "1.4.21";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "m1n1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PEjTaSwcsV8PzM9a3rDWMYXGX9FlrM0oeElrP5HYRPg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    imagemagick
  ];

  postConfigure = ''
    patchShebangs --build font/makefont.sh
    FONT_PATH=${source-code-pro}/share/fonts/opentype/SourceCodePro-Bold.otf
    rm font/{SourceCodePro-Bold.ttf,font.bin,font_retina.bin}
    ./font/makefont.sh 8 16 12 $FONT_PATH font/font.bin
    ./font/makefont.sh 16 32 25 $FONT_PATH font/font_retina.bin
  '';

  makeFlags = [
    "RELEASE=1"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 udev/80-m1n1.rules -t $out/lib/udev/rules.d/
    install -Dm644 build/m1n1.{bin,macho} -t $out/lib/m1n1/
    install -Dm644 m1n1.conf.example $out/etc/m1n1.conf

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bootloader to bridge the Apple (XNU) boot to Linux boot";
    homepage = "https://github.com/AsahiLinux/m1n1";
    changelog = "https://github.com/AsahiLinux/m1n1/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      # m1n1, minlzma, musl-libc
      mit

      # libfdt: dual BSD2 and GPL-2-or-later
      # tinf: zlib
      # arm-trusted-firmware: BSD3
      # dlmalloc: CC0
      # PDCLib: CC0
      # Source Code Pro: OFL1.1
      # dwc3: BSD3 and GPL-2-or-later
      cc0
      ofl
      zlib
      bsd2
      gpl2Plus
      bsd3
      asl20
    ];
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = [ "aarch64-linux" ];
  };
})
