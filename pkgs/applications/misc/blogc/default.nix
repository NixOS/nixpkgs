{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, ronn, git, cmocka }:

stdenv.mkDerivation rec {
  pname = "blogc";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "blogc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hx0gpvmv7rd910czafvmcpxabbvfmvdyxk4d1mckmblx8prb807";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ronn git cmocka ];

  configureFlags = [
    "--enable-git-receiver"
    "--enable-make"
    "--enable-runserver"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A blog compiler";
    license = licenses.bsd3;
    homepage = "https://blogc.rgm.io";
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
