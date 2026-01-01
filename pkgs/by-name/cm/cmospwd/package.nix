{
  lib,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmospwd";
  version = "5.1";

  src = fetchurl {
    url = "https://www.cgsecurity.org/cmospwd-${finalAttrs.version}.tar.bz2";
    hash = "sha256-8pbSl5eUsKa3JrgK/JLk0FnGXcJhKksJN3wWiDPYYvQ=";
  };

  makeFlags = [ "CC:=$(CC)" ];

  preConfigure = ''
    cd src

    # It already contains compiled executable (that doesn't work), so make
    # will refuse to build if it's still there
    rm cmospwd
  '';

  # There is no install make target
  installPhase = ''
    runHook preInstall
    install -Dm0755 cmospwd -t "$out/bin"
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Decrypt password stored in cmos used to access BIOS SETUP";
    mainProgram = "cmospwd";
    homepage = "https://www.cgsecurity.org/wiki/CmosPwd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ t4ccer ];
=======
  meta = with lib; {
    description = "Decrypt password stored in cmos used to access BIOS SETUP";
    mainProgram = "cmospwd";
    homepage = "https://www.cgsecurity.org/wiki/CmosPwd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ t4ccer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
})
