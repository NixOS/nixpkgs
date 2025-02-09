{ stdenv, lib, fetchurl, dpkg, makeWrapper, electron }:

stdenv.mkDerivation rec {
  pname = "clockify";
  version = "2.1.6";

  src = fetchurl {
    url = "https://web.archive.org/web/20231110130133/https://clockify.me/downloads/Clockify_Setup_x64.deb";
    hash = "sha256-jndoMk3vqk8a5jMzKVo6ThovSISmcu+hef9IJcg3reQ=";
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
      --replace "/opt/Clockify/" ""

    makeWrapper ${electron}/bin/electron $out/bin/clockify \
      --add-flags $out/opt/Clockify/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free time tracker and timesheet app that lets you track work hours across projects";
    homepage = "https://clockify.me";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "clockify";
    platforms = [ "x86_64-linux" ];
  };
}
