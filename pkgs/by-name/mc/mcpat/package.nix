{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mcpat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "mcpat";
    tag = "v${version}";
    sha256 = "sha256-sr7H2vBOTyI59d3itVNqRVy1fR/83ZrTGl5s4I+g0Tw=";
  };

  patches = [ ./64bit.patch ];

  buildPhase = ''
    make -f makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp mcpat $out/bin/
  '';

  meta = {
    description = "Integrated power, area, and timing modeling framework for multicore and manycore architectures ";
    homepage = "http://www.hpl.hp.com/research/mcpat/";
    changelog = "https://github.com/HewlettPackard/mcpat/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hakan-demirli ];
    platforms = lib.platforms.linux;
    mainProgram = "mcpat";
  };
}
