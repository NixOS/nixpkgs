{
  lib,
  stdenv,
  fetchFromGitHub,
  deutex,
  python3,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freedoom";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "freedoom";
    repo = "freedoom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uOLyh/epVxv3/N+6P1glBX1ZkGWzHWGaERYZRSL/3AU=";
  };

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=$(out)" ];

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    deutex
    (python3.withPackages (ps: with ps; [ pillow ]))
  ];

  meta = {
    description = "Freedoom is an entirely free software game based on the Doom engine";
    homepage = "https://github.com/freedoom/freedoom";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
