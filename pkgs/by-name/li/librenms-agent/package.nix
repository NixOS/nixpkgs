{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "librenms-agent";
  version = "1.2.6b5";

  src = fetchFromGitHub {
    owner = "librenms";
    repo = "librenms-agent";
    # upstream provides no git tags
    rev = "f6d6ff5b88bd47e738754fe72c4a4e5eb4e78d08";
    hash = "sha256-b62xkwJ09BQe/XRXZqnOr5JUpLjLIqYRETr/wTim/h4=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m 0750 check_mk_agent -t $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Agent that provides data to LibreNMS";
    homepage = "https://github.com/librenms/librenms-agent";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eliandoran ];
    platforms = platforms.linux;
  };
}
