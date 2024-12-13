{
  fetchFromGitHub,
  lib,
  buildGoModule,
  olm,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "0.5.2";
  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    tag = "v${version}";
    hash = "sha256-3sx2XxzH/cj2zJIkV9QKKVadxSWwf4YZbdg3p4repqs=";
  };

  vendorHash = "sha256-8KexkPsRqzlVeYMF0dVgDMS38zQ3i+erQgsdgHDOCF0=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  meta = {
    homepage = "https://github.com/mautrix/gmessages";
    description = "Matrix-Google Messages puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ xddxdd ];
    mainProgram = "mautrix-gmessages";
  };
}
