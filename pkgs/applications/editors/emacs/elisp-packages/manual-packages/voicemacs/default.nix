{ trivialBuild
, lib
, fetchFromGitHub
, avy
, json-rpc-server
, f
, nav-flash
, helm
, cl-lib
, porthole
, default-text-scale
, bind-key
, yasnippet
, company
, company-quickhelp
}:

trivialBuild {
  pname = "voicemacs";
  version = "0-unstable-2022-02-16";

  src = fetchFromGitHub {
    owner = "jcaw";
    repo = "voicemacs";
    rev = "d91de2a31c68ab083172ade2451419d6bd7bb389";
    sha256 = "sha256-/MBB2R9/V0aYZp15e0vx+67ijCPp2iPlgxe262ldmtc=";
  };

  patches = [ ./add-missing-require.patch ];

  packageRequires = [
    avy
    json-rpc-server
    f
    nav-flash
    helm
    cl-lib
    porthole
    default-text-scale
    bind-key
    yasnippet
    company-quickhelp
  ];

  meta = {
    description = "Voicemacs is a set of utilities for controlling Emacs by voice";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
