{ lib
, stdenv
, fetchFromGitHub
, libX11
, libXinerama
}:

stdenv.mkDerivation rec {
  pname = "focus";
  version = "unstable-2021-02-23";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "focus";
    rev = "fed2fdbd3f73b192882d97aeb5b1cea681bb7d85";
    sha256 = "sha256-IDiUXindzv5Ng5oCTyUlj2il/2kLvXG4YhgiYp7ZebQ=";
  };

  buildInputs = [ libX11 libXinerama ];

  makeFlags = [ "PREFIX=\${out}" ];

  meta = with lib; {
    description = "Focus window, workspace or monitor by direction or cycle through them";
    longDescription = ''
      A collection of utilities that change the focus of windows, workspaces or
      monitors.
    '';
    homepage = "https://github.com/phillbush/focus";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
