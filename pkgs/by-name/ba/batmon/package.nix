{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "batmon";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "6543";
    repo = "batmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3k788ckEkHi4jlSzKCebFyLJJ+UtkMERuvHInkXvSyQ=";
  };

  cargoHash = "sha256-F0lC7ELvuRCnvTWrtTEedb9j8SF2Al6XXx0PJqa7E98=";

  meta = {
    description = "Interactive batteries viewer";
    longDescription = ''
      An interactive viewer, similar to top, htop and other *top utilities,
      but about the batteries installed in your notebook.
    '';
    homepage = "https://github.com/6543/batmon/";
    changelog = "https://github.com/6543/batmon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "batmon";
    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    maintainers = with lib.maintainers; [ _6543 ];
  };
})
