{
  lib,
  buildPackages,
  fetchCrate,
  libxml2,
  libxslt,
  pkg-config,
  rustPlatform,
  stdenv,
  texliveBasic,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "latexml-oxide";
  version = "0.7.6";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "latexml";
    hash = "sha256-2OIQ8gv0wSJEk1QNKHYQOOXbzfilW45WX9bzHKOSu7c=";
  };

  cargoHash = "sha256-1/4kIhPY03eX8stbkeDu8P7BBJ+W9k5jgx9YWG4/dx4=";

  postPatch = ''
    patch -d "$cargoDepsCopy"/source-registry-0/latexml_engine-* -p1 < "${./dumps-in-share.patch}"
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    texliveBasic
  ];

  buildInputs = [
    libxml2
    libxslt
  ];

  # use kpsewhich in PATH instead of linking to libkpathsea, which Nixpkgs does not provide
  env.KPATHSEA_SKIP_TOOLCHAIN_CHECK = 1;
  # requires #![feature(thread_local)]
  env.RUSTC_BOOTSTRAP = 1;

  # create the formats after build and check, or cargo does a costly rebuild
  # with the formats embedded in the binary
  postInstall =
    if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
      ''
        mkdir -p "$out"/share/latexml-oxide/resources/dumps
        (
          cd "$out"/share/latexml-oxide
          "$out"/bin/latexml_oxide --init=plain.tex
          "$out"/bin/latexml_oxide --init=latex.ltx
        )
      ''
    else
      ''
        mkdir -p "$out"/share/latexml-oxide/resources/dumps
        cp "${buildPackages.latexml-oxide}"/share/latexml-oxide/resources/dumps/*.txt "$out"/share/latexml-oxide/resources/dumps
      '';

  meta = {
    description = "TeX to XML/HTML/ePub converter: a LaTeXML reimplementation in Rust";
    homepage = "https://crates.io/crates/latexml";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ xworld21 ];
    mainProgram = "latexml_oxide";
  };
})
