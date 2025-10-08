{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

let
  extension = lib.optionalString stdenv.hostPlatform.isMinGW ".exe";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "isocline";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "daanx";
    repo = "isocline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9hMvXa9+7XtB2pMQ3mQYccdM0wyscUooMpBwDoh1DiA=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    install -d "$out/lib" "$out/bin" "$out/include"
    install -Dm644 libisocline.a $out/lib
    install -Dm644 $src/include/*.h $out/include
    install -Dm755 example${extension} $out/bin/isocline_demo${extension}

    runHook postInstall
  '';

  meta = {
    description = "Portable GNU Readline alternative";
    homepage = "https://github.com/daanx/isocline";
    license = lib.licenses.mit;
    mainProgram = "isocline_demo${extension}";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jinser ];
  };
})
