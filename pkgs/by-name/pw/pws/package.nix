{
  stdenv,
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
  xsel,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "pws";
  version = (import ./gemset.nix).pws.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase =
    let
      env = bundlerEnv {
        name = "${pname}-gems";

        inherit ruby;

        gemdir = ./.;
      };
    in
    ''
      mkdir -p $out/bin
      makeWrapper ${env}/bin/pws $out/bin/pws \
        --set PATH '"${xsel}/bin/:$PATH"'
    '';

  passthru.updateScript = bundlerUpdateScript "pws";

  meta = {
    description = "Command-line password safe";
    homepage = "https://github.com/janlelis/pws";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      swistak35
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "pws";
  };
}
