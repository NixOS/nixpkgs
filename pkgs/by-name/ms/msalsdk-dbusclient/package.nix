{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  sdbus-cpp,
}:
stdenv.mkDerivation rec {
  pname = "msalsdk-dbusclient";
  version = "1.0.1";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/m/${pname}/${pname}_${version}_amd64.deb";
    hash = "sha256-AVPrNxCjXGza2gGETP0YrlXeEgI6AjlrSVTtqKb2UBI=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    install -m 755 usr/lib/libmsal_dbus_client.so $out/lib/
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        stdenv.cc.cc.lib
        sdbus-cpp
      ]
    } $out/lib/libmsal_dbus_client.so

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;
  meta = with lib; {
    description = "Microsoft Authentication Library cross platform Dbus client for talking to microsoft-identity-broker";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-cpp";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
