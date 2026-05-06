{
  fetchFromGitHub,
  lib,
  mdbook,
  makeWrapper,
  nix-update-script,
  rustPlatform,
  stdenvNoCC,
}:
let
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "plankevm";
    repo = "plank-monorepo";
    tag = "v${version}";
    hash = "sha256-B2UmV5i2ELlmzyrR8iFIOQcSpHeRQl4I6lxakMskolg=";
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
  strictDeps = true;

  sourceRoot = "${src.name}/plankc";
  cargoHash = "sha256-KLqTTywM6sObPO+0DzjkNqrfuKPVGKiv52HlXfR/UI0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/share/doc $out/stdlib
    cp -r ${plank-docs}/share/doc/. $out/share/doc/
    cp -r ${src}/std/. $out/stdlib/
    wrapProgram $out/bin/plank \
      --set PLANK_DIR $out
  '';

  passthru.updateScript = nix-update-script { };

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
