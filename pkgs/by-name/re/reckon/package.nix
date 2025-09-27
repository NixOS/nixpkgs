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

stdenv.mkDerivation rec {
  pname = "reckon";
  version = (import ./gemset.nix).reckon.version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      env = bundlerEnv {
        name = "${pname}-${version}-gems";

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
      version = "${version}";
    };
    updateScript = bundlerUpdateScript "reckon";
  };

  meta = with lib; {
    description = "Flexibly import bank account CSV files into Ledger for command line accounting";
    mainProgram = "reckon";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.unix;
    changelog = "https://github.com/cantino/reckon/blob/v${version}/CHANGELOG.md";
  };
}
