{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dutree";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "nachoparker";
    repo = "dutree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-57kGJHIi2N7UUIhBTzqRZNSYjMFRPO5rSiSuA5pElZ4=";
    # test directory has files with unicode names which causes hash mismatches
    # It is also not used by any tests or parts of build process
    postFetch = ''
      rm -r $out/test
    '';
  };

  cargoHash = "sha256-P3h7C6hXKhYBaf0CKlsB+4tnfj/1Aw1iFSlvMNGbSYI=";

  meta = {
    description = "Tool to analyze file system usage written in Rust";
    homepage = "https://github.com/nachoparker/dutree";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "dutree";
  };
})
