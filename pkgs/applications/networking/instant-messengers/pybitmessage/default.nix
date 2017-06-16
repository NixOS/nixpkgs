{ stdenv, fetchFromGitHub, pythonPackages, openssl }:

pythonPackages.buildPythonApplication rec {
  name = "pybitmessage-${version}";

  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bitmessage";
    repo = "PyBitmessage";
    rev = "v${version}";
    sha256 = "04sgns9qczzw2152gqdr6bjyy4fmgs26cz8n3qck94l0j51rxhz8";
  };

  propagatedBuildInputs = with pythonPackages; [ msgpack pyqt4 ] ++ [ openssl ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace "nothing = raw_input()" pass \
      --replace 'print "It looks like building the package failed.\n" \' pass \
      --replace '    "You may be missing a C++ compiler and the OpenSSL headers."' pass

  '';

  makeWrapperArgs = ''
    --prefix LD_LIBRARY_PATH : "${openssl.out}/lib/"
  '';

  meta = with stdenv.lib; {
    homepage = https://bitmessage.org/;
    description = "The official Bitmessage client";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = with platforms; linux;
  };
}
