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

stdenv.mkDerivation rec {
  pname = "lprint";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "lprint";
    rev = "v${version}";
    hash = "sha256-1OOLGQ8S4oRNSJanX/AzJ+g5F+jYnE/+o+ie5ucY22U=";
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

  meta = with lib; {
    description = "Implements printing for a variety of common label and receipt printers connected via network or USB";
    mainProgram = "lprint";
    homepage = "https://github.com/michaelrsweet/lprint";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
