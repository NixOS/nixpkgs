{
  lib,
  buildGoModule,
  fetchurl,
  zlib,
}:

buildGoModule (finalAttrs: {
  pname = "obitools4";
  version = "4.5.0";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://forge.metabarcoding.org/obitools/obitools4/archive/Release_${finalAttrs.version}.tar.gz";
    hash = "sha256-lV70TyzSbF7OXsljqF/xseRzK8qz4B72UhUWmBubtDU=";
  };

  vendorHash = "sha256-/xidfRYM15Eftonz4GbfwsrLuOzDO/BK6RSt+otpC+8=";

  buildInputs = [
    zlib
  ];

  env = {
    GOWORK = "off";
  };

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    for cmd in cmd/obitools/*/; do
      go build -trimpath -o $out/bin/$(basename "$cmd") ./$cmd
    done
    runHook postBuild
  '';

  installPhase = ":";

  meta = {
    description = "Analysis of DNA metabarcoding sequence data";
    mainProgram = "obiclean";
    homepage = "https://forge.metabarcoding.org/obitools/obitools4";
    license = lib.licenses.cecill20;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };

})
