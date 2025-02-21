{ lib, stdenv, fetchFromGitHub, cmake, php, perl, git, pkg-config, gtk3 }:
stdenv.mkDerivation rec {
  pname = "reaper-sws-extension";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "reaper-oss";
    repo = "sws";
    rev = "refs/tags/v${version}";
    hash = "sha256-aqfyyeE0WM0RCawoC7+7DrAGjCc5qd29nizGAmhH7Nw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake php perl git pkg-config ];
  buildInputs = [ gtk3 ];
  strictDeps = true;

  meta = {
    description = "A Reaper Plugin Extension";
    longDescription = ''
      The SWS / S&M extension is a collection of features that seamlessly integrate into REAPER, the Digital Audio Workstation (DAW) software by Cockos, Inc.
      It is a collaborative and open source project.
    '';
    homepage = "https://www.sws-extension.org/";
    maintainers = with lib.maintainers; [ mrtnvgr ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
