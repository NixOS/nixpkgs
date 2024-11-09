{ lib
, stdenv
, fetchFromGitHub
, writeText
, fontconfig
, libX11
, libXft
, libXcursor
, libXcomposite
, conf ? null
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ragnarwm";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "cococry";
    repo = "Ragnar";
    rev = finalAttrs.version;
    hash = "sha256-OZhIwrKEhTfkw9K8nZIwGZzxXBObseWS92Y+85HmdNs=";
  };

  prePatch = ''
    substituteInPlace Makefile \
      --replace '/usr/bin' "$out/bin" \
      --replace '/usr/share' "$out/share"
  '';

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf
        then conf else writeText "config.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.h";

  buildInputs = [
    fontconfig
    libX11
    libXft
    libXcursor
    libXcomposite
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
  '';

  postInstall = ''
    install -Dm644 $out/share/applications/ragnar.desktop $out/share/xsessions/ragnar.desktop
  '';

  passthru = {
    tests.ragnarwm = nixosTests.ragnarwm;
    providedSessions = [ "ragnar" ];
  };

  meta = {
    description = "Minimal, flexible & user-friendly X tiling window manager";
    homepage = "https://ragnar-website.vercel.app";
    changelog = "https://github.com/cococry/Ragnar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "ragnar";
    platforms = lib.platforms.linux;
  };
})
