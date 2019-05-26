{ stdenv, fetchFromGitHub, cmake, boost166 }:

stdenv.mkDerivation rec {
  name = "SkypeExport-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Temptin";
    repo = "SkypeExport";
    rev = "v${version}";
    sha256 = "1ilkh0s3dz5cp83wwgmscnfmnyck5qcwqg1yxp9zv6s356dxnbak";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost166 ];

  preConfigure = "cd src/SkypeExport/_gccbuild/linux";
  installPhase = "install -Dt $out/bin SkypeExport";

  meta = with stdenv.lib; {
    description = "Export Skype history to HTML";
    homepage = https://github.com/Temptin/SkypeExport;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
