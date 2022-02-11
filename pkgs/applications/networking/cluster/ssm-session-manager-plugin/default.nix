{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, awscli, unzip }:
let
  ver = "1.2.54.0";
  source =
    if stdenv.isDarwin then {
      url = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/mac/sessionmanager-bundle.zip";
      sha256 = "kgxoQrtu2tsV5t/3oA+Z2juY24hPOznPGjlQMsqOIZg=";
    } else {
      url = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/ubuntu_64bit/session-manager-plugin.deb";
      sha256 = "uug1cT4yRxNQcf+zWz0mi72G4EGa3eZHVuG36INSqrM=";
    };
  archivePath = if stdenv.isDarwin then "sessionmanager-bundle" else "usr/local/sessionmanagerplugin";
in
stdenv.mkDerivation rec {
  pname = "ssm-session-manager-plugin";
  version = ver;

  src = fetchurl source;

  nativeBuildInputs = [ autoPatchelfHook ] ++ (if stdenv.isDarwin then [ unzip ] else [ dpkg ]);

  unpackPhase = if stdenv.isDarwin then "unzip $src" else "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    install -m755 -D ${archivePath}/bin/session-manager-plugin $out/bin/session-manager-plugin

    runHook postInstall
  '';

  meta = with lib; {
    homepage =
      "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ mbaillie ];
  };
}
