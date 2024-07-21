{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation {
  pname = "oauth2ms";
  version = "2021-07-09";

  src = fetchFromGitHub {
    owner = "harishkrupo";
    repo = "oauth2ms";
    rev = "a1ef0cabfdea57e9309095954b90134604e21c08"; # No tags or releases in the repo
    sha256 = "sha256-xPSWlHJAXhhj5I6UMjUtH1EZqCZWHJMFWTu3a4k1ETc";
  };

  buildInputs = [
    (python3.withPackages (ps: with ps; [
      pyxdg
      msal
      python-gnupg
    ]))
  ];

  installPhase = ''
    runHook preInstall
    install -m755 -D oauth2ms $out/bin/oauth2ms
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/harishkrupo/oauth2ms";
    description = "XOAUTH2 compatible Office365 token fetcher";
    mainProgram = "oauth2ms";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ wentasah ];
  };
}
