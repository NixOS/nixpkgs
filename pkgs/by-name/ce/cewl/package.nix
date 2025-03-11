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
  version = "6.2.1";
  src = fetchFromGitHub {
    owner = "digininja";
    repo = "CeWL";
    rev = version;
    sha256 = "sha256-wMTGAB4P925z2UYNvlN4kSu1SLzKyB4a/Cjq4BofJ9w=";
  };

  buildInputs = [ rubyEnv.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.rb $out/bin/
    mv $out/bin/cewl.rb $out/bin/cewl
  '';

  passthru.updateScript = bundlerUpdateScript "cewl";

  meta = with lib; {
    description = "Custom wordlist generator";
    mainProgram = "cewl";
    homepage = "https://digi.ninja/projects/cewl.php/";
    license = licenses.gpl3Plus;
  };
}
