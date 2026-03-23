{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  writeScriptBin,
  expect,
  nano,
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "nano-syntax-highlighting";
  version = "2025.07.01";

  src = fetchFromGitHub {
    owner = "galenguyer";
    repo = pname;
    tag = version;
    hash = "sha256-+ydaxjF0CzARxyJU9h1Iq2Yj5JgtAd59sf9yH+PyavY=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share

    install *.nanorc $out/share/
  '';

  passthru = {
    tests.noSyntaxError =
      let
        expectScript = writeScriptBin "${pname}-test-syntax.exp" (builtins.readFile ./test-syntax.exp);
      in
      (runCommand "${pname}-test-noSyntaxError"
        {
          nativeBuildInputs = [
            expect
            nano
          ];
        }
        ''
          set -euo pipefail
          # For each nanorc file and each syntax, execute text-syntax.exp
          for nanorcPath in ${finalAttrs.finalPackage}/share/*.nanorc; do
            nano --rcfile "$nanorcPath" --listsyntaxes \
            | tail --lines +2 \
            | xargs --max-args 1 expect -f ${expectScript}/bin/${pname}-test-syntax.exp "$nanorcPath"
          done;
          touch $out
        ''
      );

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Improved Nano Syntax Highlighting Files, fork of nanorc";
    homepage = "https://github.com/galenguyer/nano-syntax-highlighting";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      ilai-deutel
    ];
    platforms = lib.platforms.all;
  };
})
