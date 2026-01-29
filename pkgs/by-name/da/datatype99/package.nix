{
  fetchFromGitHub,
  lib,
  metalang99,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "datatype99";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "hirrolot";
    repo = "datatype99";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5ipgE/bW4otfwwlRNuyCk80PspujvAVR+gAyaiBRkIo=";
  };

  dontBuild = true;

  propagatedBuildInputs = [ metalang99 ];

  installPhase = ''
    runHook preInstall

    install -Dm644 datatype99.h --target-directory="$out"/include

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Algebraic data types (ADT) for C99";
    longDescription = ''
      Safe, intuitive ADT with exhaustive pattern matching and
      compile-time introspection facilities.  No external tools
      required, pure C99.
    '';
    homepage = "https://github.com/hirrolot/datatype99";
    changelog = "https://github.com/hirrolot/datatype99/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
