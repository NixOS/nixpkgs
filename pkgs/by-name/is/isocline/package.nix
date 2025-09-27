{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "isocline";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "daanx";
    repo = "isocline";
    rev = "v${version}";
    hash = "sha256-9hMvXa9+7XtB2pMQ3mQYccdM0wyscUooMpBwDoh1DiA=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir $out/lib -p
    mkdir $out/bin -p
    mkdir $out/include -p

    mv -t $out/lib libisocline.a
    cp $src/include/*.h $out/include

    ${lib.optionalString (!stdenv.hostPlatform.isMinGW) ''
      mv -t $out/bin example
    ''}
    ${lib.optionalString stdenv.hostPlatform.isMinGW ''
      mv -t $out/bin example.exe
    ''}

    runHook postInstall
  '';

  meta = {
    description = "A portable GNU readline alternative";
    homepage = "https://github.com/daanx/isocline";
    license = lib.licenses.mit;
    mainProgram = "isocline";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jinser ];
  };
}
