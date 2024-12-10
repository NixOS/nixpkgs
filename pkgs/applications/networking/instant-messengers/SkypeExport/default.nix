{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "SkypeExport";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Temptin";
    repo = "SkypeExport";
    rev = "v${version}";
    sha256 = "1ilkh0s3dz5cp83wwgmscnfmnyck5qcwqg1yxp9zv6s356dxnbak";
  };

  patches = [
    (fetchpatch {
      name = "boost167.patch";
      url = "https://github.com/Temptin/SkypeExport/commit/ef60f2e4fc9e4a5764c8d083a73b585457bc10b1.patch";
      sha256 = "sha256-t+/v7c66OULmQCD/sNt+iDJeQ/6UG0CJ8uQY2PVSFQo=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  preConfigure = "cd src/SkypeExport/_gccbuild/linux";
  installPhase = "install -Dt $out/bin SkypeExport";

  meta = with lib; {
    description = "Export Skype history to HTML";
    mainProgram = "SkypeExport";
    homepage = "https://github.com/Temptin/SkypeExport";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yana ];
  };
}
