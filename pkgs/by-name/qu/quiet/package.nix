{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  _7zz,
}:

let
  pname = "quiet";
  version = "6.0.0";

  meta = {
    description = "Private, p2p alternative to Slack and Discord built on Tor & IPFS";
    homepage = "https://github.com/TryQuiet/quiet";
    changelog = "https://github.com/TryQuiet/quiet/releases/tag/@quiet/desktop@${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
  };

  linux = appimageTools.wrapType2 {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@${version}/Quiet-${version}.AppImage";
      hash = "sha256-YIkbS3L6DIof9gsgHKaguHIwGggVLjQXPM8o7810Wgs=";
    };

    meta = meta // {
      platforms = lib.platforms.linux;
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@${version}/Quiet-${version}.dmg";
      hash = "sha256-B1rT+6U0gjScr1FPuh3xGxkpfumT/8feTJbEbCgXPpo=";
    };

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    sourceRoot = "Quiet ${version}";

    unpackPhase = ''
      runHook preUnpack

      7zz x $src -x!Quiet\ ${version}/Applications

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      mv Quiet.app $out/Applications
      makeWrapper $out/Applications/Quiet.app/Contents/MacOS/Quiet $out/bin/${pname}

      runHook postInstall
    '';

    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
