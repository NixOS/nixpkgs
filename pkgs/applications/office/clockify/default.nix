{ stdenv, lib, fetchurl, dpkg, makeWrapper, electron }:

stdenv.mkDerivation rec {
  pname = "clockify";
  version = "2.0.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20211118160803/https://clockify-resources.s3.eu-central-1.amazonaws.com/downloads/Clockify_Setup.deb";
    sha256 = "sha256-eVZ3OqM1eoWfST7Qu9o8VmLm8ntD+ETf/0aes6RY4Y8=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    substituteInPlace $out/share/applications/clockify.desktop \
      --replace "/opt/Clockify" $out/bin

    makeWrapper ${electron}/bin/electron $out/bin/clockify \
      --add-flags $out/opt/Clockify/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free time tracker and timesheet app that lets you track work hours across projects";
    homepage = "https://clockify.me";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];

  };
}
