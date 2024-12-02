{ lib, stdenv, fetchFromGitHub, libjpeg }:

stdenv.mkDerivation rec {
  pname = "jhead";
  version = "3.08";

  src = fetchFromGitHub {
    owner = "Matthias-Wandel";
    repo = "jhead";
    rev = version;
    hash = "sha256-d1cuy4kkwY/21UcpNN6judrFxGVyEH+b+0TaZw9hP2E=";
  };

  buildInputs = [ libjpeg ];

  makeFlags = [ "CPPFLAGS=" "CFLAGS=-O3" "LDFLAGS=" ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    (
      cd tests
      patchShebangs runtests pretend-editor
      ./runtests
    )

    runHook postCheck
  '';

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/man/man1 \
      $out/share/doc/${pname}-${version}

    cp -v jhead $out/bin
    cp -v jhead.1 $out/man/man1
    cp -v *.txt $out/share/doc/${pname}-${version}
  '';

  meta = with lib; {
    homepage = "https://www.sentex.net/~mwandel/jhead/";
    description = "Exif Jpeg header manipulation tool";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
    mainProgram = "jhead";
  };
}
