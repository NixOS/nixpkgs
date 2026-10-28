{
  lib,
  stdenv,
  fetchFromGitHub,
  withBanner ? "Grub Bootloader", # use override to specify your own banner text
  withStyle ? "light", # use override to specify one of "dark" / "orange" / "bigSur"
}:

assert builtins.elem withStyle [
  "light"
  "dark"
  "orange"
  "bigSur"
];

stdenv.mkDerivation {
  pname = "sleek-grub-theme";
  version = "0-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "sandesh236";
    repo = "sleek--themes";
    rev = "e103aa4cd655be6a38dbab37b1911c6ed9ef7765";
    hash = "sha256-E3DSOZlszBRy2F172L7ZSSsDlkk3n9jGXl4hRWv2WF8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/

    cp -r 'Sleek theme-${withStyle}'/sleek/* $out/
    sed -i "s/Grub Bootloader/${withBanner}/" $out/theme.txt

    runHook postInstall
  '';

  meta = {
    description = "Grub bootloader themes, contains light/dark/orange/bigSur styles";
    homepage = "https://github.com/sandesh236/sleek--themes";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ luochen1990 ];
  };
}
