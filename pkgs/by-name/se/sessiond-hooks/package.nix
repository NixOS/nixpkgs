{
  lib,
  fetchgit,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "sessiond-hooks";
  version = "0.1.0";

  cargoHash = "sha256-XD2g3nkV4iz9ZQlb0+0YDuJl+8XdMOdwbMcCnCjKGT8=";

  src = fetchgit {
    url = "https://tangled.org/did:plc:ujej26vte653yzllxk3q2dtf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zVEHxDNjF0xRydp2Y+oqM6O5KqM4zZTv0IqlHGXCgsA=";
  };

  meta = {
    description = "Launch and supervise per-user session hooks with sessiond";
    homepage = "https://tangled.org/did:plc:ujej26vte653yzllxk3q2dtf";
    license = lib.licenses.gpl3Only;
    maintainers = builtins.attrValues { inherit (lib.maintainers) r0chd; };
    platforms = lib.platforms.linux;
    mainProgram = "sessiond-hooks";
  };
})
