{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "electrum-server-${version}";
  version = "2016-10-10";

  src = fetchFromGitHub {
    owner = "spesmilo";
    repo = "electrum-server";
    rev = "c46e6daae4f257b2b28a362933c091d0b3ef9f43";
    sha256 = "0n89m6brzpx0ys2cc5w0igpw1d6548f27qzgn70paijvcc37gfg7";
  };

  propagatedBuildInputs = with pythonPackages; [
    irc jsonrpclib plyvel
  ];

  postPatch = ''
    sed -i 's/, *<=14.0//g' setup.py
  '';

  meta = with stdenv.lib; {
    description = "Electrum server";
    homepage = https://electrum.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
