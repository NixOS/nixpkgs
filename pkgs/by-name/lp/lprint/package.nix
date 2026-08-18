{
  lib,
  stdenv,
  fetchFromGitHub,
  pappl,
  cups,
  pkg-config,
  # Enables support for untested printers. It makes sense to default this to true, as it's unlikely to result in any issues
  enableExperimental ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lprint";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "lprint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-r5mOwkU828btDdt0y7JrEl6KSim8VaF/y4R58zPX3eI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pappl
    cups
  ];

  configureFlags = lib.optional enableExperimental "--enable-experimental";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/lprint --help
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Implements printing for a variety of common label and receipt printers connected via network or USB";
    mainProgram = "lprint";
    homepage = "https://github.com/michaelrsweet/lprint";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
