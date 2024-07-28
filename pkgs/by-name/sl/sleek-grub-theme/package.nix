{ lib
, stdenv
, fetchFromGitHub
, withBanner ? "Grub Bootloader" # use override to specify your own banner text
, withStyle ? "light" # use override to specify one of "dark" / "orange" / "bigSur"
}:

assert builtins.any (s: withStyle == s) ["light" "dark" "orange" "bigSur"];

stdenv.mkDerivation {
  pname = "sleek-grub-theme";
  version = "unstable-2023-12-31";

  src = fetchFromGitHub ({
    owner = "sandesh236";
    repo = "sleek--themes";
    rev = "0a680163a0711c4ed23d5d3b1b9a0f67115cb6d8";
    hash = "sha256-bof/4Ab9XmhlG7kRQfVGzsyClAW2bctHn4kdcIJox9o=";
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
