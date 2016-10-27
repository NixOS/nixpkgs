{ stdenv, fetchFromGitHub, pythonPackages, openssl }:

stdenv.mkDerivation rec {
  name = "pybitmessage-${version}";

  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "bitmessage";
    repo = "PyBitmessage";
    rev = "v${version}";
    sha256 = "1f4h0yc1mfjnxzvxiv9hxgak59mgr3a5ykv50vlyiay82za20jax";
  };

  buildInputs = with pythonPackages; [ python pyqt4 wrapPython ] ++ [ openssl ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "PREFIX?=/usr/local" "" \
      --replace "/usr" ""
  '';

  makeFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    substituteInPlace $out/bin/pybitmessage \
      --replace "exec python2" "exec ${pythonPackages.python}/bin/python" \
      --replace "/opt/openssl-compat-bitcoin/lib/" "${openssl.out}/lib/"
    wrapProgram $out/bin/pybitmessage \
      --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://bitmessage.org/;
    description = "The official Bitmessage client";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = with platforms; linux;
  };
}
