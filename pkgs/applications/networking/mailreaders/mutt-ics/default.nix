{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname   = "mutt-ics";
  version = "2020-02-26";

  src = fetchFromGitHub {
    owner = "dmedvinsky";
    repo = pname;
    rev = "ac54116be429cb92230f03ec8d3cdbdceaf8f008";
    sha256 = "1ppy94k87q7nfpxmajry1mn42c960n8zd9ka10g1jfjwkby2rmp8";
  };

  buildInputs = with python3Packages; [
    icalendar
    dateutil
  ];

  meta = with stdenv.lib; {
    description = "Simple viewer for ics in mutt";
    homepage = https://github.com/dmedvinsky/mutt-ics;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
}

