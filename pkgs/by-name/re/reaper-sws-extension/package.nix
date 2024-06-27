{ lib, stdenv, fetchFromGitHub, cmake, php, perl, git, pkg-config, gtk3 }:
stdenv.mkDerivation {
  pname = "reaper-sws-extension";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "reaper-oss";
    repo = "sws";
    rev = "a3693ad52ed16fe95ac0a570971656b6c9337f26";
    hash = "sha256-ALntLopjjzZaBsSapzuV4WCkmaUvcR8DtiWI+pvE8g4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ php perl git pkg-config gtk3 ];

  meta = with lib; {
    description = "A Reaper Plugin Extension";
    longDescription = ''
      The SWS / S&M extension is a collection of features that seamlessly integrate into REAPER, the Digital Audio Workstation (DAW) software by Cockos, Inc.
      It is a collaborative and open source project.
    '';
    homepage = "https://www.sws-extension.org/";
    maintainers = with maintainers; [ mrtnvgr ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
