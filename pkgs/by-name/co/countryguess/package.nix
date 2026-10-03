{
  lib,
  python3Packages,
  fetchFromCodeberg,
  makeWrapper,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "countryguess";
  version = "0-unstable-2025-05-03";
  # upstream pyproject.toml is nonsense. Copied from another project
  # without customizing it for this project.
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "sbird";
    repo = "countryguess";
    rev = "36d840cbd27d3f0103f2786b7f64796965d23a9a";
    hash = "sha256-OaCHrUvUKvdTNophi9qpGMzAIDcKfRJ9o5DkT1PrwDc=";
  };

  __structuredAttrs = true;

  dependencies = with python3Packages; [
    art
    colorama
  ];

  # upstream python file lacks shebang
  postPatch = ''
    echo '#!/usr/bin/env python3' | cat - countryguess.py > temp && mv temp countryguess.py
  '';

  installPhase = ''
    runHook preInstall

    install -Dm744 countryguess.py $out/bin/countryguess

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Guess the 193 U.N. recognised countries";
    homepage = "https://codeberg.org/sbird/countryguess";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "countryguess";
  };
}
