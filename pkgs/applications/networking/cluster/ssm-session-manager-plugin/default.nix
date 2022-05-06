{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, awscli, unzip }:
let
  ver = "1.2.312.0";
  source =
    if stdenv.isDarwin then {
      url = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/mac/sessionmanager-bundle.zip";
      sha256 = "50aac34a4dedddf20c20be24989ee5d33b46a72187791715fb9b395b54db8ef9";
    } else {
      url = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/ubuntu_64bit/session-manager-plugin.deb";
      sha256 = "2e51ce5bf8f23a1e590fff866bbdadcf82aa03c5054c671d9115482a1b263cc7";
    };
  archivePath = if stdenv.isDarwin then "sessionmanager-bundle" else "usr/local/sessionmanagerplugin";
in
stdenv.mkDerivation rec {
  pname = "ssm-session-manager-plugin";
  version = ver;

  src = fetchurl source;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
    dpkg
  ] ++ lib.optionals stdenv.isDarwin [
    unzip
  ];

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
