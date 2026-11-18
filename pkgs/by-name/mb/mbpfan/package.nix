{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbpfan";
  version = "2.5.0";
  src = fetchFromGitHub {
    owner = "linux-on-mac";
    repo = "mbpfan";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ep3JFFZD2l6gynUohXPtl7VJmfm6sAU5k5SWPPjUcSE=";
  };
  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp bin/mbpfan $out/bin
    cp mbpfan.conf $out/etc
  '';
  meta = {
    description = "Daemon that uses input from coretemp module and sets the fan speed using the applesmc module";
    mainProgram = "mbpfan";
    homepage = "https://github.com/linux-on-mac/mbpfan";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
