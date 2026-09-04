{
  lib,
  fetchgit,
  rustPlatform,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-ps-rs";
  version = "7.3.3";

  __structuredAttrs = true;

  src = fetchgit {
    url = "git://git.drewdeponte.com/git-ps-rs.git";
    tag = finalAttrs.version;
    hash = "sha256-0Umv9BaM6bPrLlCn6rnrr195UlBDNTQc9WPJNvRTPF0=";
  };

  cargoHash = "sha256-MZwKDqUGbzRzwiTzYqzVqaAWTNq991gG9TRJubD68Cs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    dbus
  ];

  meta = {
    description = "Tool for working with a stack of patches";
    mainProgram = "gps";
    homepage = "https://git-ps.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alizter ];
  };
})
