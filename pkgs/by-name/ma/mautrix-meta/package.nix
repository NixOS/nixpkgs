{ buildGoModule
, fetchFromGitHub
, lib
, nixosTests
, olm
# This option enables the use of an experimental pure-Go implementation of the
# Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
# recommended by the mautrix developers, but they are interested in people
# trying it out in non-production-critical environments and reporting any
# issues they run into.
, withGoolm ? false
}:

buildGoModule rec {
  pname = "mautrix-meta";
  version = "0.3.2";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    rev = "v${version}";
    hash = "sha256-whBqhdB2FSFfrbtGtq8v3pjXW7QMt+I0baHTXVGPWVg=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-rP9wvF6yYW0TdQ+vQV6ZcVMxnCtqz8xRcd9v+4pYYio=";

  passthru = {
    tests = {
      inherit (nixosTests)
        mautrix-meta-postgres
        mautrix-meta-sqlite
        ;
    };
  };

  meta = {
    homepage = "https://github.com/mautrix/meta";
    description = "Matrix <-> Facebook and Mautrix <-> Instagram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ rutherther ];
    mainProgram = "mautrix-meta";
  };
}
