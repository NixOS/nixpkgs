{
  stdenv,
  pname,
  meta,
  fetchurl,
  undmg,
  lib,
}:

stdenv.mkDerivation {
  inherit pname;

  version = "5.16.0.2";

  src =
    # WARNING: This Wayback Machine URL redirects to the closest timestamp.
    # Future maintainers must manually check the timestamp exists and exactly matches at:
    # https://web.archive.org/web/*/https://mega.nz/MEGAsyncSetupArm64.dmg
    # https://web.archive.org/web/*/https://mega.nz/MEGAsyncSetup.dmg
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20250926041253/https://mega.nz/MEGAsyncSetupArm64.dmg";
        hash = "sha256-zXkkWIZkZteDC+wnhgU3HoP33AfLm1YOAGWgrkmc4Sg=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20250926041517/https://mega.nz/MEGAsyncSetup.dmg";
        hash = "sha256-Mehx5ttSmaBp/x8oZue5BwBQoUNwJL00SLeiCGU+jRo=";
      });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [ iedame ];
  };
}
