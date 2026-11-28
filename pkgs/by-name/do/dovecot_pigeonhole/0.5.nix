import ./generic.nix {
  version = "0.5.21.1";
  url =
    {
      version,
      dovecotMajorMinor,
    }:
    "https://pigeonhole.dovecot.org/releases/${dovecotMajorMinor}/dovecot-${dovecotMajorMinor}-pigeonhole-${version}.tar.gz";
  hash = "sha256-andOWZmgWYIPATEk0V+mHmReL+quG81azwPkBMoo9OE=";
  knownVulnerabilities = [
    "Pigeonhole 0.5 is the Sieve plugin for Dovecot CE 2.3, which is end of life upstream. It has had no release since 0.5.21.1 (2024-08). Consider switching to pkgs.dovecot_pigeonhole (2.4.x)."
  ];
}
