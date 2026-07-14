{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i810switch";
  version = "0.6.5";

  src = fetchurl {
    url = "http://www16.plala.or.jp/mano-a-mano/i810switch/i810switch-${finalAttrs.version}.tar.gz";
    hash = "sha256-1xSEDjsU4fqcQyxL4ARLfACNkE3s4NYRVUZVuXnK1MM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    make clean

    substituteInPlace i810switch.c \
      --replace-fail 'define CMD_LSPCI "lspci"' 'define CMD_LSPCI "${lib.getExe' pciutils "lspci"}"'
  '';

  installPhase = "
    runHook preInstall

    install -Dm755 -t $out/bin i810switch i810rotate

    installManPage i810switch.1.gz i810rotate.1.gz

    runHook postInstall
  ";

  # Ignore errors since gcc-14.
  #   i810switch.c:251:34: error: passing argument 2 of 'getline' from incompatible pointer type [-Wincompatible-pointer-types]
  #   i810switch.c:296:34: error: passing argument 2 of 'getline' from incompatible pointer type [-Wincompatible-pointer-types]
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    description = "Utility for switching between the LCD and external VGA display on Intel graphics cards";
    homepage = "http://www16.plala.or.jp/mano-a-mano/i810switch.html";
    maintainers = [ ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "i810switch";
  };
})
