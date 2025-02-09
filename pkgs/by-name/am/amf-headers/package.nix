{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "amf-headers";
  version = "1.4.36";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "AMF";
    rev = "v${version}";
    sha256 = "sha256-u6gvdc1acemd01TO5EbuF3H7HkEJX4GUx73xCo71yPY=";
  };

  installPhase = ''
    mkdir -p $out/include/AMF
    cp -r amf/public/include/* $out/include/AMF
  '';

  meta = with lib; {
    description = "Headers for The Advanced Media Framework (AMF)";
    homepage = "https://github.com/GPUOpen-LibrariesAndSDKs/AMF";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.unix;
  };
}
