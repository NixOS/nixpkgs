{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc-arm-embedded-13,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nitrokey-start-firmware";
  version = "13";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-start-firmware";
    tag = "RTM.${finalAttrs.version}";
    hash = "sha256-POW1d/fgOyYa7127FSTCtHGyMWYzKW0qqA1WUyvNc3w=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    patchShebangs configure
  '';

  # Avoid additional arguments are added to configureFlags
  configurePlatforms = [ ];

  # from release/Makefile
  configureFlags = [
    "--target=NITROKEY_START-g"
    "--vidpid=20a0:4211"
    "--enable-factory-reset"
    "--enable-certdo"
  ];

  nativeBuildInputs = [ gcc-arm-embedded-13 ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp build/gnuk.{bin,hex} $out/
    runHook postInstall
  '';

  meta = {
    description = "Firmware for the Nitrokey Start device";
    homepage = "https://github.com/Nitrokey/nitrokey-start-firmware";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      amerino
      imadnyc
      kiike
    ];
    platforms = lib.platforms.unix;
  };
})
