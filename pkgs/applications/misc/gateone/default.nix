{ stdenv
, fetchFromGitHub
, python
, cacert
, openssh
, openssl
}:

python.pkgs.buildPythonApplication rec {
  pname = "gateone";
  version = "1.2-0d57c3";

  disabled = python.pkgs.isPy3k;

  src = fetchFromGitHub {
    rev = "1d0e8037fbfb7c270f3710ce24154e24b7031bea";
    owner= "liftoff";
    repo = "GateOne";
    sha256 = "1ghrawlqwv7wnck6alqpbwy9mpv0y21cw2jirrvsxaracmvgk6vv";
  };

  propagatedBuildInputs = [
    cacert
    openssh
    openssl
    python.pkgs.futures
    python.pkgs.html5lib
    python.pkgs.tornado_4
  ];

  postInstall=''
    cp -R "$out/gateone/"* $out/${python.sitePackages}/gateone
  '';

  meta = with stdenv.lib; {
    homepage = https://liftoffsoftware.com/;
    description = "GateOne is a web-based terminal emulator and SSH client";
    maintainers = with maintainers; [ tomberek ];
    license = licenses.gpl3;
  };
}
