{ stdenv, fetchFromGitHub, cmake, pkgconfig, zip, gettext, perl
, wxGTK30, libXext, libXi, libXt, libXtst, xercesc
, qrencode, libuuid, libyubikey, yubikey-personalization
, curl, openssl, file
}:

stdenv.mkDerivation rec {
  pname = "pwsafe";
  version = "3.53.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0nh5jnf5yls2qv5hpfhm6i854zsknyh7d93c987a0cg14sg820fv";
  };

  nativeBuildInputs = [
    cmake gettext perl pkgconfig zip
  ];
  buildInputs = [
    libXext libXi libXt libXtst wxGTK30
    curl qrencode libuuid openssl xercesc
    libyubikey yubikey-personalization
    file
  ];

  cmakeFlags = [
    "-DNO_GTEST=ON"
    "-DCMAKE_CXX_FLAGS=-I${yubikey-personalization}/include/ykpers-1"
  ];
  enableParallelBuilding = true;

  postPatch = ''
    # Fix perl scripts used during the build.
    for f in `find . -type f -name '*.pl'`; do
      patchShebangs $f
    done

    # Fix hard coded paths.
    for f in `grep -Rl /usr/share/ src`; do
      substituteInPlace $f --replace /usr/share/ $out/share/
    done

    # Fix hard coded zip path.
    substituteInPlace help/Makefile.linux --replace /usr/bin/zip ${zip}/bin/zip

    for f in `grep -Rl /usr/bin/ .`; do
      substituteInPlace $f --replace /usr/bin/ ""
    done
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "A password database utility";
    longDescription = ''
      Password Safe is a password database utility. Like many other
      such products, commercial and otherwise, it stores your
      passwords in an encrypted file, allowing you to remember only
      one password (the "safe combination"), instead of all the
      username/password combinations that you use.
    '';
    homepage = "https://pwsafe.org/";
    maintainers = with maintainers; [ c0bw3b pjones ];
    platforms = platforms.linux;
    license = licenses.artistic2;
  };
}
