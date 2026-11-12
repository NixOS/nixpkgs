{
  lib,
  stdenv,
  fetchFromSourcehut,
  lua5_5,
}:

let
  lua = lua5_5;
  luaPackages = lua.luaOnBuild.pkgs;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fnlfmt";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = "fnlfmt";
    tag = finalAttrs.version;
    hash = "sha256-8ZDT7CVWWKaFclU4yCgT9JUR+jCwMrA+6F11os65JHQ=";
  };

  nativeBuildInputs = [ luaPackages.fennel ];

  buildInputs = [ lua ];

  makeFlags = [
    "PREFIX=$(out)"
    "FENNEL=${luaPackages.fennel}/bin/fennel"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/fnlfmt --help > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Formatter for Fennel";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/tree/${finalAttrs.version}/changelog.md";
    license = lib.licenses.mit;
    platforms = lua.meta.platforms;
    maintainers = with lib.maintainers; [ chiroptical ];
    mainProgram = "fnlfmt";
  };
})
