{ darwin
, p7zip
, libarchive
, stdenv
, lib
, fetchurl
}:
{ pname, version, url, hash }:

let
  inherit (stdenv) targetPlatform;
  ARCH = if targetPlatform.isArch64 then "arm64" else "x64";
in stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    inherit url hash;
  };

  unpackPhase = lib.optionalString stdenv.isDarwin
  ''
    7z x $src
    bsdtar -xf Payload~
  '';

  nativeBuildInputs = lib.optionalString stdenv.isDarwin [
    p7zip
    libarchive
  ];

  installPhase = lib.optionalString stdenv.isDarwin
  ''
    runHook preInstall

    mkdir -p $out/Applications
    ls
    cp -R Applications/Nextcloud.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://nextcloud.com";
    license = licenses.gpl2Plus;
    maintainers = [  ];
    platforms = platforms.darwin;
    mainProgrm = "nextcloud";
  };
}

