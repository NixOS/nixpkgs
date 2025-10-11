{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  source-code-pro,
  python3Packages,
  nix-update-script,
  nixos-icons,
  customLogo ? "${nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "m1n1";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "m1n1";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J1PZVaEdI6gx/qzsoVW1ehRQ/ZDKzdC1NgIGgBqxQ+0=";
  };

  postPatch = lib.optionalString (customLogo != null) ''
    magick ${customLogo} -resize 128x128 data/custom_128.png
    magick ${customLogo} -resize 256x256 data/custom_256.png
  '';

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
    "ARCH=${stdenv.cc.targetPrefix}"
    "RELEASE=1"
    (lib.optionalString (customLogo != null) "LOGO=custom")
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 build/m1n1.bin -t $out/lib/m1n1/

    install -Dm644 3rdparty_licenses/LICENSE.* -t $out/share/doc/m1n1/licenses/
    install -Dm644 LICENSE -t $out/share/doc/m1n1/licenses/

    runHook postInstall
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeCheckInputs = with python3Packages; [
    pytest
  ];

  checkInputs = with python3Packages; [
    construct
    pyserial
  ];

  checkPhase = ''
    runHook preCheck

    pytest

    runHook postCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bootloader to bridge the Apple (XNU) boot to Linux boot";
    longDescription = ''
      m1n1 is the bootloader developed by the Asahi Linux project to
      bridge the Apple (XNU) boot ecosystem to the Linux boot ecosystem.

      What it does:

      - Initializes hardware
      - Puts up a pretty Nix logo
      - Loads embedded (appended) payloads, which can be:
         - Device Trees (FDTs), with automatic selection based on the platform
         - Initramfs images (compressed CPIO archives)
         - Kernel images in Linux ARM64 boot format (optionally compressed)
         - Configuration statements

      The default Nix logo can be disabled by setting the `customLogo`
      argument to `null` or can be replaced by setting `customLogo` to
      a path to the desired image file which will be resized by
      ImageMagick to the correct sizes.
    '';
    homepage = "https://github.com/AsahiLinux/m1n1";
    changelog = "https://github.com/AsahiLinux/m1n1/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      # m1n1 embeds several libraries, all of which cannot be
      # unvendored easily.

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
    platforms = lib.platforms.aarch64;
  };
})
