{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neatmail";
  version = "05-unstable-2026-06-26";

  src = fetchFromGitHub {
    owner = "aligrudi";
    repo = "neatmail";
    rev = "5eac6d2640cd7777bb449fec46b242f2116b556b";
    hash = "sha256-cVQNzDOT6xngzx+M6/GKjdJIg36QqnyolactxtQ3swo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 mail $out/bin/neatmail
    install -Dm644 README $out/share/doc/neatmail/README

    runHook postInstall
  '';

  doCheck = true;

  meta = {
    description = "A text-mode email client";
    homepage = "https://github.com/aligrudi/neatmail";
    mainProgram = "neatmail";
    platforms = lib.platforms.unix;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
