{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "novnc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "novnc";
    repo = "noVNC";
    rev = "v${version}";
    sha256 = "sha256-Z+bks7kcwj+Z3uf/t0u25DnGOM60QhSH6uuoIi59jqU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 utils/novnc_proxy "$out/bin/novnc"
    install -dm755 "$out/share/webapps/novnc/"
    cp -a app core po vendor vnc.html karma.conf.js package.json vnc_lite.html "$out/share/webapps/novnc/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "VNC client web application";
    homepage = "https://novnc.com";
    license = with licenses; [ mpl20 ofl bsd3 bsd2 mit ];
    maintainers = with maintainers; [ neverbehave ];
  };
}
