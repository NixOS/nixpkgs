{ stdenv, rustPlatform, pkg-config, sqlite
, dbPath ? "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite" }:

rustPlatform.buildRustPackage {
  name = "command-not-found";
  src = ./rust;

  DB_PATH = dbPath;
  NIX_SYSTEM = stdenv.system;

  postInstall = ''
    strip $out/bin/command-not-found
  '';

  buildInputs = [ sqlite ];
  nativeBuildInputs = [ pkg-config ];
  cargoSha256 = "13q61bb4b1q40g424pbssyp3ln79q1a33vmyz9s9wlqnac34cibd";
}
