{ lib
, stdenv
, fetchurl
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ode";
  version = "0.16.5";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/ode/downloads/ode-${finalAttrs.version}.tar.gz";
    hash = "sha256-uode3RZFcJWHle6qcPFIU7/DTMmHH4rd6NpH4SvVRnk=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.GLUT
  ];

  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang (toString [
    "-std=c++14"
    "-Wno-error=c++11-narrowing"
  ]);

  meta = with lib; {
    description = "Open Dynamics Engine";
    mainProgram = "ode-config";
    homepage = "https://www.ode.org";
    license = with licenses; [ bsd3 lgpl21Only lgpl3Only zlib ];
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
})
