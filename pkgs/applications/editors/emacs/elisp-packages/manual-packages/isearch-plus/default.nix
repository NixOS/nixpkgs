{ lib
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild {
  pname = "isearch-plus";
  version = "3434-unstable-2021-08-23";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-plus";
    rev = "93088ea0ac4d51bdb76c4c32ea53172f6c435852";
    hash = "sha256-kD+Fyps3fc5YK6ATU1nrkKHazGMYJnU2gRcpQZf6A1E=";
  };

  meta = with lib; {
    homepage = "https://www.emacswiki.org/emacs/IsearchPlus";
    description = "Extensions to isearch";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leungbk AndersonTorres ];
    inherit (emacs.meta) platforms;
  };
}
