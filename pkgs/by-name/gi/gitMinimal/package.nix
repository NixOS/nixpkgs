{
  git,
  stdenv,
  cargo,
  curl,
  curlMinimal,
  ...
}@args:
git.override (
  {
    withManual = false;
    osxkeychainSupport = false;
    pythonSupport = false;
    perlSupport = false;
    rustSupport = false; # Needed for bootstrap
    withpcre2 = false;
    cargo = cargo.override { auditable = false; }; # Break `cargo-auditable` -> `fetch-cargo-vendor` -> `nix-prefetch-git` -> `gitMinimal` cycle`
    curl = if stdenv.hostPlatform.isFreeBSD then curlMinimal else curl; # Needed for FreeBSD bootstrap
  }
  // removeAttrs args [
    "git"
    "cargo"
    "curl"
    "curlMinimal"
  ]
)
