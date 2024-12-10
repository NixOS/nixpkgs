{
  lib,
  stdenv,
  fetchFromGitHub,
  withBanner ? "Grub Bootloader", # use override to specify your own banner text
  withStyle ? "white", # use override to specify one of "dark" / "orange" / "bigSur"
}:

assert builtins.any (s: withStyle == s) [
  "white"
  "dark"
  "orange"
  "bigSur"
];

stdenv.mkDerivation {
  pname = "sleek-grub-theme";
  version = "unstable-2022-06-04";

  src = fetchFromGitHub ({
    owner = "sandesh236";
    repo = "sleek--themes";
    rev = "981326a8e35985dc23f1b066fdbe66ff09df2371";
    hash = "sha256-yD4JuoFGTXE/aI76EtP4rEWCc5UdFGi7Ojys6Yp8Z58=";
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
