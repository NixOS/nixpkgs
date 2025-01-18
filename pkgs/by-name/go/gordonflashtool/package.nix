{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
  unixtools,
}:

let
  version = "10";
in

stdenv.mkDerivation {
  pname = "gordonflashtool";
  inherit version;

  src = fetchFromGitHub {
    owner = "marmolak";
    repo = "GordonFlashTool";
    rev = "release-${version}";
    hash = "sha256-/zpw7kVdQeR7QcRsP1+qcu8+hlEQTGwOKClJkwVcBPg=";
  };

  nativeBuildInputs = [
    nasm
    unixtools.xxd
  ];

  buildPhase = ''
    runHook preBuild
    # build the gordon binary
    make all-boot-code
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 gordon $out/bin/gordon
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/marmolak/GordonFlashTool";
    description = "Toolset for Gotek SFR1M44-U100 formatted usb flash drives";
    maintainers = with maintainers; [ marmolak ];
    license = licenses.bsd3;
    platforms = platforms.all;
    mainProgram = "gordon";
  };
}
