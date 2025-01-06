{
  lib,
  fetchFromGitHub,
  rustPlatform,
  notmuch,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "mujmap";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qb9fEPQrdn+Ek9bdOMfaPIxlGGpQ9RfQZOeeqoOf17E=";
  };

  cargoHash = "sha256-nnAYjutjxtEpDNoWTnlESDO4Haz14wZxY4gdyzdLgBU=";

  buildInputs = [
    notmuch
  ] ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = {
    description = "JMAP integration for notmuch mail";
    homepage = "https://github.com/elizagamedev/mujmap/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ elizagamedev ];
    mainProgram = "mujmap";
  };
}
