{ lib, stdenv, fetchFromGitHub, python3, texinfo, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ponysay";
  version = "unstable-2021-03-27";

  src = fetchFromGitHub {
    owner = "erkin";
    repo = "ponysay";
    rev = "8a2c71416e70e4e7b0931917ebfd6479f51ddf9a";
    sha256 = "sha256-LNc83E+7NFYYILORElNlYC7arQKGUJHv6phu+vM5xpQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 texinfo ];

  inherit python3;

  installPhase = ''
    runHook preInstall

    find -type f -name "*.py" | xargs sed -i "s@/usr/bin/env python3@$python3/bin/python3@g"
    substituteInPlace setup.py --replace \
        "fileout.write(('#!/usr/bin/env %s\n' % env).encode('utf-8'))" \
        "fileout.write(('#!%s/bin/%s\n' % (os.environ['python3'], env)).encode('utf-8'))"
    python3 setup.py --prefix=$out --freedom=partial install \
        --with-shared-cache=$out/share/ponysay \
        --with-bash

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cowsay reimplemention for ponies";
    homepage = "https://github.com/erkin/ponysay";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bodil ];
    platforms = platforms.unix;
  };
}
