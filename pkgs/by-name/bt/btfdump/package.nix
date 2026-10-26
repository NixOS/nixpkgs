{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  cargo-hack,
  rustc,
  zlib,
  libxml2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "btfdump";
  version = "0.0.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-iLYGFXB4goiY7eJXXBhX9Y1TOltsW40ogeBhvTV2NvU=";
  };

  cargoHash = "sha256-uGp9XaqepceUmaEKBVEcu8oorfMAOk8BCPIHtun8Sto=";

  meta = {
    description = "BTF introspection tool";
    mainProgram = "btf";
    homepage = "https://github.com/anakryiko/btfdump";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
