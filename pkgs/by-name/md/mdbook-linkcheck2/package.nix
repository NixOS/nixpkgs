{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  mdbook-linkcheck2,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-linkcheck2";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "mdbook-linkcheck2";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-SvheBEIWiL1zdYeMQalbBeAQC86DycqV1/PTA+0S7Gg=";
  };

  cargoHash = "sha256-s4nvVHl/bViIxZfqc4SxSnCCYIY/hxy0C7f2/9ztqts=";

  doCheck = false; # tries to access network to test broken web link functionality

  passthru.tests.version = testers.testVersion { package = mdbook-linkcheck2; };

  meta = {
    description = "Backend for mdbook which will check your links for you";
    mainProgram = "mdbook-linkcheck2";
    homepage = "https://github.com/marxin/mdbook-linkcheck2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      scandiravian
    ];
  };
})
