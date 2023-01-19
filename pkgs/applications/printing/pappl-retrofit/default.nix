{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, cups
, libcupsfilters
, libppd
, pappl
}:

stdenv.mkDerivation rec {
  pname = "pappl-retrofit";
  version = "1.0b1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "pappl-retrofit";
    rev = version;
    hash = "sha256-B39pSTn37iVu3BxlwN/6OmyV9Kvf2KeZnvGGrNeoq1M=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    cups
    pappl
    libcupsfilters
    libppd
  ];

  postInstall = ''
    rm -rf $out/var
  '';

  meta =
    let homepage = "https://github.com/OpenPrinting/pappl-retrofit";
    in with lib; {
      description = "PPD/Classic CUPS driver retro-fit Printer Application Library";
      inherit homepage;
      changelog = "${homepage}/releases/tag/${version}";
      license = licenses.asl20;
      maintainers = with maintainers; [ tmarkus ];
      platforms = platforms.unix;
    };
}

