{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "darkhttpd";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "emikulic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dcNoGU08tu950PlwSghoZwGSaSbP8NJ5qhWUi3bAtZY=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin darkhttpd
    install -Dm444 -t $out/share/doc/${pname} README.md
    head -n 18 darkhttpd.c > $out/share/doc/${pname}/LICENSE
    runHook postInstall
  '';

  meta = with lib; {
    description = "Small and secure static webserver";
    mainProgram = "darkhttpd";
    homepage = "https://unix4lyfe.org/darkhttpd/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.all;
  };
}
