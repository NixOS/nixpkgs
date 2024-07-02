{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgsCross,
  libpng,
  python3Packages,
  requireFile,
  ido-static-recomp
}:

let

  baseRom = requireFile {
    name = "baserom.mm.us.rev1.z64";
    message = ''
      mm-decomp currently only supports the US version of Majora's Mask.

      Please rename your copy to baserom.mm.us.rev1.z64 and add it to the nix store using

      nix-store --add-fixed sha256 baserom.mm.us.rev1.z64

      and rebuild.
    '';
    hash = "sha256-77E2WzrjYmBFFMD5oaLRH13IaIulvmYKN96/XjvkPys=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mm-decomp";
  version = "0-unstable-2023-10-29";

  src = fetchFromGitHub {
    owner = "zeldaret";
    repo = "mm";
    rev = "23beee0717364de43ca9a82957cc910cf818de90";
    hash = "sha256-ZhT8gaiglmSagw7htpnGEoPUesSaGAt+UYr9ujiDurE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with python3Packages; [
    argcomplete
    colorama
    cxxfilt
    levenshtein
    libyaz0
    mapfile-parser
    pyelftools
    rabbitizer
    watchdog
  ];

  buildInputs = [ libpng ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace-fail "mips-linux-gnu-ld" "${pkgsCross.mips-linux-gnu.buildPackages.bintools}/bin/mips-unknown-linux-gnu-ld" \
      --replace-fail "mips-linux-gnu-" "${pkgsCross.mips-linux-gnu.buildPackages.bintools}/bin/mips-unknown-linux-gnu-"

    # Replace included IDO binaries with ours
    rm -r ./tools/ido_recomp/linux/{5.3,7.1}/*
    cp ${ido-static-recomp}/bin/5.3/* ./tools/ido_recomp/linux/5.3/
    cp ${ido-static-recomp}/bin/7.1/* ./tools/ido_recomp/linux/7.1/
  '';

  preBuild = ''
    ln -s ${baseRom} ./baserom.mm.us.rev1.z64
    patchShebangs ./tools/fado/find_program.sh
  '';

  buildFlags = [ "init" ];

  # Fix line to allow mm-decomp to compile per upstream instructions
  patches = [ ./0001-mm-decomp-fix-build.patch ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin mm.us.rev1.rom_uncompressed.elf
    install -Dm755 -t $out/bin mm.us.rev1.rom_uncompressed.z64

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Decompilation of The Legend of Zelda: Majora's Mask";
    homepage = "https://github.com/zeldaret/mm";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = [ "x86_64-linux" ];
  };
})
