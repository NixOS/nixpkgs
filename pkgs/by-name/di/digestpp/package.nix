{ lib
, fetchFromGitHub
, stdenvNoCC
}:
stdenvNoCC.mkDerivation {
  pname = "digestpp";
  version = "0-unstable-2023-11-07";

  src = fetchFromGitHub {
    owner = "kerukuro";
    repo = "digestpp";
    rev = "ebb699402c244e22c3aff61d2239bcb2e87b8ef8";
    hash = "sha256-9X/P7DgZB6bSYjQWRli4iAXEFjhmACOVv3EYQrXuH5c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/digestpp
    cp -r *.hpp algorithm/ detail/ $out/include/digestpp

    runHook postInstall
  '';

  meta = with lib; {
    description = "C++11 header-only message digest library";
    homepage = "https://github.com/kerukuro/digestpp";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ambroisie ];
    platforms = platforms.all;
  };
}
