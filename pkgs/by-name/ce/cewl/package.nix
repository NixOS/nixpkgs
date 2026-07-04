{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  bundlerUpdateScript,
}:

let
  rubyEnv = bundlerEnv {
    name = "cewl-ruby-env";
    gemdir = ./.;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cewl";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "digininja";
    repo = "CeWL";
    tag = finalAttrs.version;
    hash = "sha256-wMTGAB4P925z2UYNvlN4kSu1SLzKyB4a/Cjq4BofJ9w=";
  };

  buildInputs = [ rubyEnv.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.rb $out/bin/
    mv $out/bin/cewl.rb $out/bin/cewl
  '';

  passthru.updateScript = bundlerUpdateScript "cewl";

  meta = {
    description = "Custom wordlist generator";
    homepage = "https://digi.ninja/projects/cewl.php/";
    changelog = "https://github.com/digininja/CeWL/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "cewl";
  };
})
