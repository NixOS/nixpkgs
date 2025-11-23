{ lib, stdenv, fetchFromGitHub, nimble }:

stdenv.mkDerivation rec {
  pname = "nitchrevived";
  version = "0.1.7.5";

  src = fetchFromGitHub {
    owner = "gnuvalerie";
    repo = "nitchrevived";
    tag = "${version}";
    sha256 = "sha256-R0grP4QcQeTvUAvSYCAxwD0Nw3fEXPWP3ImE60lK3QA=";
  };

  nativeBuildInputs = [ nimble ];

  buildPhase = ''
    export HOME=$TMPDIR
    cd src
    nimble build -d:release -d:danger --opt:speed --passC:-march=native --passC:-O3 --passL:-s
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nitchrevived $out/bin/
  '';

  meta = with lib; {
    description = "Incredibly fast system fetch written in Nim";
    homepage = "https://github.com/gnuvalerie/nitchrevived";
    license = licenses.mit;
    maintainers = [ maintainers.gnuvalerie ];
    platforms = platforms.linux;
  };
}
