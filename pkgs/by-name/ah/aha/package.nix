{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "aha";
  version = "0.5.1";

  src = fetchFromGitHub {
    hash = "sha256-+10K7CWrCq8/yh7/Z4WEwhTQre4MfapWYePvnUFT3L8=";
    rev = version;
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
