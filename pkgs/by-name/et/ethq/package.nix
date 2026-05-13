{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ethq";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "isc-projects";
    repo = "ethq";
    tag = "v${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-ye5ep9EM9Sq/NqNZHENPmFZefVBx1BGrPm3YEG1NcSc=";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m0755 ethq $out/bin/ethq

    runHook postInstall
  '';

  meta = {
    description = "Ethernet NIC Queue stats viewer";
    mainProgram = "ethq";
    homepage = "https://github.com/isc-projects/ethq";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
