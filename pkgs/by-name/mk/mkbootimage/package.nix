{
  lib,
  stdenv,
  fetchFromGitHub,
  elfutils,
  pcre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkbootimage";
  version = "2.3-unstable-2022-05-26";

  src = fetchFromGitHub {
    owner = "antmicro";
    repo = "zynq-mkbootimage";
    rev = "872363ce32c249f8278cf107bc6d3bdeb38d849f";
    hash = "sha256-5FPyAhUWZDwHbqmp9J2ZXTmjaXPz+dzrJMolaNwADHs=";
  };

  # Using elfutils because libelf is being discontinued
  # See https://github.com/NixOS/nixpkgs/pull/271568
  buildInputs = [
    elfutils
    pcre
  ];

  postPatch = ''
    substituteInPlace Makefile --replace "git rev-parse --short HEAD" "echo ${finalAttrs.src.rev}"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 mkbootimage -t $out/bin

    runHook postInstall
  '';

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "An open source replacement of the Xilinx bootgen application";
    homepage = "https://github.com/antmicro/zynq-mkbootimage";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.fsagbuya ];
    mainProgram = "mkbootimage";
  };
})
