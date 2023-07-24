{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, fmt_9
, libnotify
, spdlog
, wireplumber
}:

stdenv.mkDerivation rec {
  pname = "wp-notifyd";
  version = "unstable-2023-07-24";

  src = fetchFromGitHub {
    owner = "LDAP";
    repo = pname;
    rev = "1d46728a43ca7d9f207b8309071ed8f22968e617";
    hash = "sha256-UGz3AAFXpoEwxUk+SwD9zhVGWqpbJ6Prex1Gz9eTTDw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fmt_9
    libnotify
    spdlog
    wireplumber
  ];

  meta = with lib; {
    description = "A notification daemon for Wireplumber";
    homepage = "https://github.com/LDAP/wp-notifyd";
    license = licenses.mit;
    maintainers = with maintainers; [ fee1-dead ];
  };
}
