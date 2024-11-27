{ lib
, stdenv
, fetchFromGitHub
, gmp
, jpcre2
, pcre2
}:

stdenv.mkDerivation rec {
  pname = "rnm";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "neurobin";
    repo = "rnm";
    rev = "refs/tags/${version}";
    hash = "sha256-cMWIxRuL7UCDjGr26+mfEYBPRA/dxEt0Us5qU92TelY=";
  };

  buildInputs = [
    gmp
    jpcre2
    pcre2
  ];

  meta = with lib; {
    homepage = "https://neurobin.org/projects/softwares/unix/rnm/";
    description = "Bulk rename utility";
    changelog = "https://github.com/neurobin/rnm/blob/${version}/ChangeLog";
    platforms = lib.platforms.all;
    license = licenses.gpl3Only;
    mainProgram = "rnm";
  };
}
