{
  fetchFromGitHub,
  lib,
  mdbook,
  makeWrapper,
  rustPlatform,
  stdenvNoCC,
}:
let
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "plankevm";
    repo = "plank-monorepo";
    tag = "v${version}";
    hash = "sha256-4r/hYPlVIKzq1/50mivs6CJjObAS5Iq1inwRe1bFlzE=";
  };

  plank-docs = stdenvNoCC.mkDerivation {
    pname = "plank-docs";
    inherit version src;
    __structuredAttrs = true;
    strictDeps = true;

    sourceRoot = "${src.name}/plank-doc";

    nativeBuildInputs = [ mdbook ];

    buildPhase = ''
      mdbook build
    '';

    installPhase = ''
      mkdir -p $out/share/doc
      cp -r book/. $out/share/doc/
      cp -r src $out/share/doc/src
    '';
  };
in
rustPlatform.buildRustPackage {
  pname = "plankc";
  inherit version src;
  __structuredAttrs = true;

  sourceRoot = "${src.name}/plankc";
  cargoHash = "sha256-BPHkNQGlAqUVvQs8Sx5w0SNyglg0pSETIFjuc0XQXzk=";

  nativeBuildInputs = [ makeWrapper ];

  # Let plank know about its actual version.
  env.PLANK_VERSION = version;

  postInstall = ''
    mkdir -p $out/share/doc $out/stdlib
    cp -r ${plank-docs}/share/doc/. $out/share/doc/
    cp -r ${src}/std/. $out/stdlib/
    wrapProgram $out/bin/plank \
      --set PLANK_DIR $out
  '';

  meta = {
    changelog = "https://github.com/plankevm/plank-monorepo/releases/tag/v${version}";
    description = "Compiler for Plank, an EVM-Native smart contract language";
    homepage = "https://plankevm.org";
    license = lib.licenses.mit;
    mainProgram = "plank";
    maintainers = with lib.maintainers; [
      _0xferrous
      hythera
    ];
  };
}
