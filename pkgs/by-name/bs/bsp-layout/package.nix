{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, git
, bc
, bspwm
}:

stdenv.mkDerivation rec {
  pname = "bsp-layout";
  version = "unstable-2022-06-19";

  src = fetchFromGitHub {
    owner = "phenax";
    repo = pname;
    rev = "9d60fc271454ea1bfca598575207a06d8d172d3e";
    sha256 = "sha256-7bBVWJdgAnXLWzjQGZxVqhku2rsxX2kMxU4xkI9/DHE=";
  };

  nativeBuildInputs = [ makeWrapper git bc ];
  buildInputs = [ bspwm ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    substituteInPlace $out/lib/bsp-layout/layout.sh --replace 'bc ' '${bc}/bin/bc '
    for layout in tall rtall wide rwide
    do
      substituteInPlace "$out/lib/bsp-layout/layouts/$layout.sh" --replace 'bc ' '${bc}/bin/bc '
    done
  '';

  meta = with lib; {
    description = "Manage layouts in bspwm";
    longDescription = ''
      bsp-layout is a dynamic layout manager for bspwm, written in bash.
      It provides layout options to fit most workflows.
    '';
    homepage = "https://github.com/phenax/bsp-layout";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.linux;
    mainProgram = "bsp-layout";
  };
}
