{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ode";
  version = "0.16.6";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/ode/downloads/ode-${finalAttrs.version}.tar.gz";
    hash = "sha256-yRooxv8mUChHhKeccmo4DWr+yH7PejXDKmvgxbdFE+g=";
  };

  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang (toString [
    "-std=c++14"
    "-Wno-error=c++11-narrowing"
  ]);

<<<<<<< HEAD
  meta = {
    description = "Open Dynamics Engine";
    mainProgram = "ode-config";
    homepage = "https://www.ode.org";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Open Dynamics Engine";
    mainProgram = "ode-config";
    homepage = "https://www.ode.org";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bsd3
      lgpl21Only
      lgpl3Only
      zlib
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
=======
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
