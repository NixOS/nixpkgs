{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "aha";
  version = "0.5.1";

  src = fetchFromGitHub {
    sha256 = "1gywad0rvvz3c5balz8cxsnx0562hj2ngzqyr8zsy2mb4pn0lpgv";
    tag = version;
    repo = "aha";
    owner = "theZiz";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "ANSI HTML Adapter";
    mainProgram = "aha";
    longDescription = ''
      aha takes ANSI SGR-coloured input and produces W3C-conformant HTML code.
    '';
    homepage = "https://github.com/theZiz/aha";
    changelog = "https://github.com/theZiz/aha/blob/${version}/CHANGELOG";
    license = with lib.licenses; [
      lgpl2Plus
      mpl11
    ];
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.all;
  };
}
