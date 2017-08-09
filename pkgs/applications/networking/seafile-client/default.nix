{ stdenv, fetchurl, fetchpatch, writeScript, pkgconfig, cmake, qtbase, qttools
, seafile-shared, ccnet, makeWrapper }:

stdenv.mkDerivation rec {
  version = "6.1.0";
  name = "seafile-client-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz";
    sha256 = "16rn6b9ayaccgwx8hs3yh1wb395pp8ffh8may8a8bpcc4gdry7bd";
  };

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];
  buildInputs = [ qtbase qttools seafile-shared ];

  patches = [
    (fetchpatch {
      url = "https://github.com/haiwen/seafile-client/pull/940.patch";
      sha256 = "1wpnkbkcszm0vas3y4yrdqv5nl6rnsylqsql87li5gg5by0n296r";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/seafile-applet \
      --suffix PATH : ${stdenv.lib.makeBinPath [ ccnet seafile-shared ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile-client;
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.calrama ];
  };
}
