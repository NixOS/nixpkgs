{
  lib,
  libconfuse,
  stdenv,
  fetchFromGitHub,
  cmake,
  help2man,
}:

stdenv.mkDerivation rec {
  pname = "postsrsd";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "sha256-Q7tXCd2Mz3WIGnIrbb8mfgT7fcmtVS4EtF0ztYmEsmM=";
  };

  cmakeFlags = [
    "-DGENERATE_SRS_SECRET=OFF"
    "-DINIT_FLAVOR=systemd"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-DINSTALL_SYSTEMD_SERVICE=OFF"
  ];

  preConfigure = ''
    sed -i "s,\"/etc\",\"$out/etc\",g" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    help2man
  ];

  buildInputs = [
    libconfuse
  ];

  meta = with lib; {
    homepage = "https://github.com/roehling/postsrsd";
    description = "Postfix Sender Rewriting Scheme daemon";
    mainProgram = "postsrsd";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
