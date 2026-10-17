{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbpad";
  version = "05";

  src = fetchFromGitHub {
    owner = "aligrudi";
    repo = "fbpad";
    tag = finalAttrs.version;
    hash = "sha256-Tue5bwTNBi3HaWtrY8Prv6kehpxsZeqlwW8ENYtFPj0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 fbpad $out/bin/fbpad

    runHook postInstall
  '';

  meta = {
    description = "A Linux framebuffer terminal emulator";
    homepage = "https://github.com/aligrudi/fbpad";
    mainProgram = "fbpad";
    platforms = lib.platforms.linux;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
