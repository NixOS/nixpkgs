{ python3, fetchFromGitHub, nautilus-python, stdenv, lib }:
stdenv.mkDerivation rec {
  pname = "owncloud-client-nautilus";
  version = "5.0.0";

  src = fetchFromGitHub {
      owner = "owncloud";
      repo = "client-desktop-shell-integration-nautilus";
      rev = "refs/tags/v${version}";
      hash = "sha256-BhluDyMBrv6K85VjHWFO48y8hp36FmMs1U342yuQdi8=";
  };

  buildInputs = [
    nautilus-python
    python3.pkgs.pygobject3
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 ./src/syncstate.py -t $out/share/nautilus-python/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "ownCloud client extension for Nautilus";
    license = licenses.gpl2;
    maintainers = with maintainers; [ e-renna ];
    homepage = "https://github.com/owncloud/client-desktop-shell-integration-nautilus";
    platforms = platforms.linux;
  };
}
