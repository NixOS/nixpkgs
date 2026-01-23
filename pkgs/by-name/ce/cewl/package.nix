{
  stdenv,
  lib,
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
stdenv.mkDerivation rec {
  pname = "cewl";
  version = "5.5.2";
  src = fetchFromGitHub {
    owner = "digininja";
    repo = "CeWL";
    tag = version;
    hash = "sha256-5LTZUr3OMeu1NODhIgBiVqtQnUWYfZTm73q61vT3rXc=";
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
    mainProgram = "cewl";
    homepage = "https://digi.ninja/projects/cewl.php/";
    license = lib.licenses.gpl3Plus;
  };
}
