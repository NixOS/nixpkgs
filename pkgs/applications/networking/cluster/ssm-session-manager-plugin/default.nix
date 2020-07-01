{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, awscli }:
stdenv.mkDerivation rec {
  pname = "ssm-session-manager-plugin";
  version = "1.1.61.0";

  src = fetchurl {
    url =
      "https://s3.amazonaws.com/session-manager-downloads/plugin/${version}/ubuntu_64bit/session-manager-plugin.deb";
    sha256 = "0z59irrpwhjjhn379454xyraqs590hij2n6n6k25w5hh8ak7imfl";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ awscli ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase =
    "install -m755 -D usr/local/sessionmanagerplugin/bin/session-manager-plugin $out/bin/session-manager-plugin";

  meta = with lib; {
    homepage =
      "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ mbaillie ];
  };
}
