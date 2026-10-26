{
  stdenv,
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  makeWrapper,
  file,
  testers,
  reckon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reckon";
  version = (import ./gemset.nix).reckon.version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      env = bundlerEnv {
        name = "${finalAttrs.pname}-${finalAttrs.version}-gems";

        gemdir = ./.;
      };
    in
    ''
      runHook preInstall
      mkdir -p $out/bin
      makeWrapper ${env}/bin/reckon $out/bin/reckon \
        --prefix PATH : ${lib.makeBinPath [ file ]}
      runHook postInstall
    '';

  passthru = {
    tests.version = testers.testVersion {
      package = reckon;
      version = "${finalAttrs.version}";
    };
    updateScript = bundlerUpdateScript "reckon";
  };

  meta = {
    description = "Flexibly import bank account CSV files into Ledger for command line accounting";
    mainProgram = "reckon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicknovitski ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/cantino/reckon/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
