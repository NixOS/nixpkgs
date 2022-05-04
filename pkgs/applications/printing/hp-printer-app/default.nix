{ lib, stdenv, fetchFromGitHub, cups, pappl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "hp-printer-app";
  version = "unstable-2022-05-04";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = pname;
    rev = "fe874c0ed080968ccb6c09c3d764d2f5e05655b0";
    sha256 = "sha256-OYVdiQoC3w0Ve614RGHlnwh9X7utzzzCZxMaILolaTQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pappl cups ];

  NIX_LDFLAGS = "-lm";
  makeFlags = "prefix=${placeholder "out"}";

  meta = with lib; {
    description =
      "Example printer application for HP PCL printers using PAPPL";
    homepage = "https://github.com/michaelrsweet/${pname}";
    license = licenses.asl20;
    platforms =
      platforms.linux; # should also work for darwin, but requires additional work
    maintainers = with maintainers; [ ckie ];
  };
}
