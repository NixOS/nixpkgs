{
  lib,
  stdenv,
  fetchFromGitHub,
  scsh,
  feh,
  xorg,
  xdg-user-dirs,
}:

stdenv.mkDerivation {
  pname = "deco";
  version = "0-unstable-2025-07-07";

  src = fetchFromGitHub {
    owner = "vedatechnologiesinc";
    repo = "deco";
    rev = "2fd28241ed28c07b9d641061d4e1bf3cacfcc7a0";
    hash = "sha256-kjXEvgYO1p/dX9nXQ3HHcXmJdtxDM6xzKqDQu3yM4Tw=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp deco $out/bin
    chmod +x $out/bin/deco
  '';

  postFixup = ''
    substituteInPlace $out/bin/deco --replace-fail "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/deco --replace-fail "feh" "${feh}/bin/feh"
    substituteInPlace $out/bin/deco --replace-fail "xdpyinfo" "${xorg.xdpyinfo}/bin/xdpyinfo"
    substituteInPlace $out/bin/deco --replace-fail "xdg-user-dir" "${xdg-user-dirs}/bin/xdg-user-dir"
  '';

  meta = {
    homepage = "https://github.com/vedatechnologiesinc/deco";
    description = "Simple root image setter";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ebzzry ];
    platforms = lib.platforms.unix;
    mainProgram = "deco";
  };

  dontBuild = true;
}
