{ lib, stdenv, fetchFromGitHub, nasm, unixtools }:

let
  version = "10";
in

stdenv.mkDerivation {
  pname = "gordonflashtool";
  inherit version;

  src = fetchFromGitHub {
    owner = "marmolak";
    repo = "GordonFlashTool";
    rev = "release-10";
    sha256 = "sha256-/zpw7kVdQeR7QcRsP1+qcu8+hlEQTGwOKClJkwVcBPg=";
  };

  nativeBuildInputs = [ nasm unixtools.xxd ];

  buildPhase = ''
    # build the gordon binary
    make all-boot-code
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gordon $out/bin/gordon
  '';

  meta = {
    homepage = "https://github.com/marmolak/GordonFlashTool";
    description = "Toolset for Gotek SFR1M44-U100 formatted usb flash drives.";
    maintainers = with lib.maintainers; [ marmolak ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "gordon";
  };
}
