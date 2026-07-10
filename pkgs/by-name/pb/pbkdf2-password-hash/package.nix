{
  fetchgit,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "pbkdf2-password-hash";
  version = "0-unstable-2024-03-21";

  src = fetchgit {
    url = "https://git.sr.ht/~laalsaas/pbkdf2-password-hash";
    rev = "9dfc0fd353bda7a6ccffbf681efc9a26dcc29a90";
    hash = "sha256-eBRArvcGU+63VT8Fx6iIi5RP9F55860CwF4Q3YwT8WU=";
  };

  cargoHash = "sha256-n3VxmR+bjFN/mEJ/SuDYQJWcndR7QFmcVJdZhSHDdmQ=";

  __structuredAttrs = true;

  meta = {
    description = "Prompts for a password and prints the pbkdf2 hash";
    homepage = "https://git.sr.ht/~laalsaas/pbkdf2-password-hash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pbkdf2-hash-password";
  };
}
