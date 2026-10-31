{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  libiconv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "monolith";
  version = "2.11.7";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = "monolith";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oaH31j5KDOQmI4pyGokTvQqypZakg2P7KdXHO78EzSA=";
  };

  cargoHash = "sha256-LMYjxPvndu1ZT5MXHW0pEKjh/FbM9WhS//oH8I9LIIM=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [ cacert ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bundle any web page into a single HTML file";
    mainProgram = "monolith";
    homepage = "https://github.com/Y2Z/monolith";
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
  };
})
