{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, withBanner ? "Grub Bootloader" # use override to specify your own banner text
, withStyle ? "light" # use override to specify one of "dark" / "orange" / "bigSur"
}:

assert builtins.any (s: withStyle == s) ["light" "dark" "orange" "bigSur"];

stdenv.mkDerivation {
  pname = "sleek-grub-theme";
  version = "unstable-2024-06-16";

  src = fetchFromGitHub ({
    owner = "sandesh236";
    repo = "sleek--themes";
    rev = "0a680163a0711c4ed23d5d3b1b9a0f67115cb6d8";
    hash = "sha256-bof/4Ab9XmhlG7kRQfVGzsyClAW2bctHn4kdcIJox9o=";
  });

  # Rename patches broken. This fix comes from luochen1990
  # See https://github.com/sandesh236/sleek--themes/pull/25
  prePatch = ''
    mv 'Sleek theme-white'/sleek/icons/* 'Sleek theme-light'/sleek/icons/
  '';

  patches = [
    (fetchpatch2 {
      name = "fix-bigSur-typo.patch";
      url = "https://github.com/sandesh236/sleek--themes/commit/58097d7ca3d6c2cac4e6faf461fbee38986e8d2d.patch";
      hash = "sha256-lIa4MFG3txgGlv1vRg9U6bCR6Pe4qpKobLTNGx+243U=";
    })
  ];

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
