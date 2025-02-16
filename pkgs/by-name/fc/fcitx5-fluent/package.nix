{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-fluent";
  version = "0.4.0-unstable-2024-03-30";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "Fluent-fcitx5";
    rev = "dc98bc13e8eadabed7530a68706f0a2a0a07340e";
    hash = "sha256-d1Y0MUOofBxwyeoXxUzQHrngL1qnL3TMa5DhDki7Pk8=";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r FluentDark FluentDark-solid FluentLight FluentLight-solid $out/share/fcitx5/themes
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fluent-design theme with blur effect and shadow";
    homepage = "https://github.com/Reverier-Xu/Fluent-fcitx5";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ oosquare ];
  };
}
