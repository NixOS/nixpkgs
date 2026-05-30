import ./generic.nix {
  version = "0.5.21.1";
  url =
    {
      version,
      dovecotMajorMinor,
    }:
    "https://pigeonhole.dovecot.org/releases/${dovecotMajorMinor}/dovecot-${dovecotMajorMinor}-pigeonhole-${version}.tar.gz";
  hash = "sha256-andOWZmgWYIPATEk0V+mHmReL+quG81azwPkBMoo9OE=";
}
