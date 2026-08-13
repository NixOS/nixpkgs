{
  lib,
  docutils,
  fetchFromGitHub,
  libelfin,
  ncurses,
  pkg-config,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "coz";
  version = "0.2.2";
  pyproject = false; # Built with make

  src = fetchFromGitHub {
    owner = "plasma-umass";
    repo = "coz";
    tag = version;
    hash = "sha256-tvFXInxjodB0jEgEKgnOGapiVPomBG1hvrhYtG2X5jI=";
  };

  nativeBuildInputs = [
    pkg-config
    ncurses
    docutils
  ];

  buildInputs = [
    ncurses
    libelfin
  ];

  dependencies = [ python3Packages.docutils ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  strictDeps = true;

  # fix executable includes
  postInstall = ''
    chmod -x $out/include/coz.h
  '';

  meta = {
    homepage = "https://github.com/plasma-umass/coz";
    description = "Profiler based on casual profiling";
    mainProgram = "coz";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      zimbatm
      aleksana
    ];
  };
}
