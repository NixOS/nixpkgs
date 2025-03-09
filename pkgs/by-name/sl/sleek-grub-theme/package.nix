{
  lib,
  stdenv,
  fetchFromGitHub,
  withBanner ? "Grub Bootloader", # use override to specify your own banner text
  withStyle ? "light", # use override to specify one of "dark" / "orange" / "bigSur"
}:

assert builtins.any (s: withStyle == s) [
  "light"
  "dark"
  "orange"
  "bigSur"
];

stdenv.mkDerivation {
  pname = "sleek-grub-theme";
  version = "unstable-2024-08-11";

  src = fetchFromGitHub ({
    owner = "sandesh236";
    repo = "sleek--themes";
    rev = "0c47e645ccc2d72aa165e9d994f9d09f58de9f6d";
    hash = "sha256-H4s4CSR8DaH8RT9w40hkguNNcC0U8gHKS2FLt+FApeA=";
  });

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
