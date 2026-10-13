{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autotiling-rs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "autotiling-rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PuWSS2676IGmbjhiMEpHiOPfOoXyqNEQSbb6pd6FUHc=";
  };

  cargoHash = "sha256-E+nn6rMbj1FzN0bl5jX3YnSHotSaXZGp3AdZuGlziv0=";

  meta = {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "autotiling-rs";
  };
})
