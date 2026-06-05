{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:
stdenv.mkDerivation {
  pname = "dell-bios-fan-control";
  version = "0-unstable-2022-01-19";

  src = fetchFromGitHub {
    owner = "TomFreudenberg";
    repo = "dell-bios-fan-control";
    rev = "27006106595bccd6c309da4d1499f93d38903f9a";
    hash = "sha256-3ihzvwL86c9VJDfGpbWpkOwZ7qU0E5U2UuOeCwPMR1s=";
  };

  nativeBuildInputs = [ installShellFiles ];

  hardeningDisable = [
    "fortify"
  ];

  installPhase = ''
    runHook preInstall

    installBin dell-bios-fan-control

    runHook postInstall
  '';

  meta = {
    description = "Simple tool to enable or disable the SMBIOS (auto) fan control on various Dell laptops";
    homepage = "https://github.com/TomFreudenberg/dell-bios-fan-control";
    license = lib.licenses.gpl2Plus;
    mainProgram = "dell-bios-fan-control";
    maintainers = with lib.maintainers; [ rickyelopez ];
    platforms = [ "x86_64-linux" ];
  };
}
