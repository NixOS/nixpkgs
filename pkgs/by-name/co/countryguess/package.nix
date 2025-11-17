{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
}:

python3Packages.buildPythonApplication {
  pname = "countryguess";
  version = "0-unstable-2025-03-04";
  # upstream pyproject.toml is nonsense. Copied from another project
  # without customizing it for this project.
  format = "other";

  src = fetchFromGitHub {
    owner = "swarbler";
    repo = "countryguess";
    rev = "28f45231bc3d8bedeb7d1b51d56ca1b56796ff8c";
    hash = "sha256-S/fy94aRoVI2CvICrviQ2ZgVESWYLuREb5mwsfXL6Hc=";
  };

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

  meta = {
    description = "Guess the 193 U.N. recognised countries";
    homepage = "https://github.com/swarbler/countryguess";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "countryguess";
  };
}
