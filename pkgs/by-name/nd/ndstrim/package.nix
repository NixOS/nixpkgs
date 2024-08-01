{ lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ndstrim";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Nemris";
    repo = "ndstrim";
    rev = "v${version}";
    hash = "sha256-KgtejBbFg6+klc8OpCs1CIb+7uVPCtP0/EM671vxauk=";
  };

  patches = [
    # https://github.com/Nemris/ndstrim/pull/1
    (fetchpatch {
      name = "update-cargo-lock.patch";
      url = "https://github.com/Nemris/ndstrim/commit/8147bb31a8fb5765f33562957a61cb6ddbe65513.patch";
      hash = "sha256-HsCc5un9dg0gRkRjwxtjms0cugqWhcTthGfcF50EgYA=";
    })
  ];

  cargoHash = "sha256-k5SlsIWHEZaYwk5cmLb1QMs3lk0VGGwiGd1TSQJC3Ss=";

  # TODO: remove this after upstream merge above patch.
  # Without the workaround below the build results in the following error:
  # Validating consistency between /build/source/Cargo.lock and /build/ndstrim-0.2.1-vendor.tar.gz/Cargo.lock
  # <hash>
  # < version = "0.2.1"
  # ---
  # > version = "0.1.0"
  #
  # ERROR: cargoHash or cargoSha256 is out of date
  postPatch = ''
    cargoSetupPostPatchHook() { true; }
  '';

  meta = with lib; {
    description = "Trim the excess padding found in Nintendo DS(i) ROMs";
    homepage = "https://github.com/Nemris/ndstrim";
    changelog = "https://github.com/Nemris/ndstrim/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thiagokokada ];
    mainProgram = "ndstrim";
  };
}
