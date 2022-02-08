{ lib
, stdenv
, fetchFromGitHub
, cmake
, gettext
, perl
, pkg-config
, zip
, ApplicationServices
, AVFoundation
, Carbon
, curl
, file
, libXext
, libXi
, libXt
, libXtst
, libuuid
, libyubikey
, qrencode
, openssl
, wxGTK30
, wxmac
, xercesc
, yubikey-personalization
}:

stdenv.mkDerivation rec {
  pname = "pwsafe";
  version = "1.14.0"; # do NOT update to 3.x Windows releases
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-s3IXe4gTwUOzQslNfWrcN/srrG9Jv02zfkGgiZN3C1s=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    perl
    pkg-config
    zip
  ];

  buildInputs = [
    curl
    file
    libXext
    libXi
    libXt
    libXtst
    libuuid
    libyubikey
    qrencode
    openssl
    xercesc
    yubikey-personalization
  ] ++ lib.optionals (!stdenv.isDarwin) [ wxGTK30 ]
    ++ lib.optionals (stdenv.isDarwin) [
      ApplicationServices
      AVFoundation
      Carbon
      wxmac
  ];

  cmakeFlags = [
    "-DNO_GTEST=ON"
    "-DCMAKE_CXX_FLAGS=-I${yubikey-personalization}/include/ykpers-1"
  ];

  postPatch = ''
    # Fix perl scripts used during the build.
    for f in $(find . -type f -name '*.pl') ; do
      patchShebangs $f
    done

    # Fix hard coded paths.
    for f in $(grep -Rl /usr/share/ src install/desktop) ; do
      substituteInPlace $f --replace /usr/share/ $out/share/
    done

    # Fix hard coded zip path.
    substituteInPlace help/Makefile.linux --replace /usr/bin/zip ${zip}/bin/zip

    for f in $(grep -Rl /usr/bin/ .) ; do
      substituteInPlace $f --replace /usr/bin/ ""
    done
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
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
    platforms = platforms.unix;
    license = licenses.artistic2;
  };
}
