{
  lib,
  rustPlatform,
  fetchpatch,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emplace";
  version = "1.6.0";

  src = fetchFromCodeberg {
    owner = "fosk";
    repo = "emplace";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-FZ+lvf5HRSruUdmkm/Hqz0aRa95SjfIa43WQczRCGNg=";
  };

  cargoPatches = [
    (fetchpatch {
      url = "https://codeberg.org/fosk/emplace/commit/ea39f5826f6d0501aa3073f620b8a764900d3dc5.patch";
      hash = "sha256-9O0J9cJlXUGdQ9fqWeW8OIFA48qlYxGl+2yHHt3MaMU=";
    })
  ];

  cargoHash = "sha256-nBpM8i4jlxtnaonOx71DWjbLS8tYznJkoR2JI/B25LM=";

  meta = {
    description = "Mirror installed software on multiple machines";
    homepage = "https://codeberg.org/fosk/emplace";
    license = lib.licenses.agpl3Plus;
    mainProgram = "emplace";
  };
})
