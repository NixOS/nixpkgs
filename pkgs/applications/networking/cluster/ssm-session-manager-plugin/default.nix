{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, awscli, unzip }:
let
  ver = "1.2.7.0";
  source = if stdenv.isDarwin then {
    url =
      "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/mac/sessionmanager-bundle.zip";
    sha256 = "sha256-HP+opNjS53zR9eUxpNUHGD9rZN1z7lDc6+nONR8fa/s=";
  } else {
    url =
      "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/ubuntu_64bit/session-manager-plugin.deb";
    sha256 = "sha256-EZ9ncj1YYlod1RLfXOpZFijnKjLYWYVBb+C6yd42l34=";
  };
  platformBuildInput = if stdenv.isDarwin then [ unzip ] else [ dpkg ];
  unpackCmd = if stdenv.isDarwin then "unzip $src" else "dpkg-deb -x $src .";
  archivePath = if stdenv.isDarwin then "sessionmanager-bundle" else "usr/local/sessionmanagerplugin";
in
stdenv.mkDerivation rec {
  pname = "ssm-session-manager-plugin";
  version = ver;

  src = fetchurl source;

  nativeBuildInputs = [ autoPatchelfHook ] ++ platformBuildInput;

  buildInputs = [ awscli ];

  unpackPhase = unpackCmd;

  installPhase = "install -m755 -D ${archivePath}/bin/session-manager-plugin $out/bin/session-manager-plugin";

  meta = with lib; {
    homepage =
      "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ mbaillie ];
  };
}
