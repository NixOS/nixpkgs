{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost }:

stdenv.mkDerivation (finalAttrs: {
  pname = "skypeexport";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Temptin";
    repo = "SkypeExport";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uy3bmylDm/3T7T48zBkuk3lbnWW6Ps4Huqz8NjSAk8Y=";
  };

  patches = [
    (fetchpatch {
      name = "boost167.patch";
      url = "https://github.com/Temptin/SkypeExport/commit/ef60f2e4fc9e4a5764c8d083a73b585457bc10b1.patch";
      hash = "sha256-t+/v7c66OULmQCD/sNt+iDJeQ/6UG0CJ8uQY2PVSFQo=";
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
    maintainers = [ ];
  };
})
