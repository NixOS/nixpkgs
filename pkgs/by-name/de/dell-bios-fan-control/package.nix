{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dell-bios-fan-control";
  version = "0-unstable-2022-01-19";

  src = fetchFromGitHub {
    owner = "TomFreudenberg";
    repo = "dell-bios-fan-control";
    rev = "27006106595bccd6c309da4d1499f93d38903f9a";
    hash = "sha256-3ihzvwL86c9VJDfGpbWpkOwZ7qU0E5U2UuOeCwPMR1s=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp dell-bios-fan-control $out/bin
  '';

  meta = {
    description = "A user space utility to set control of fans by bios on some older Dell laptops.";
    homepage = "https://www.github.com/TomFreudenberg/dell-bios-fan-control";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ totalyenglizlitrate ];
    mainProgram = "dell-bios-fan-control";
    platforms = lib.platforms.linux;
  };
})
