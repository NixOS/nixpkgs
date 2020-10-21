{ stdenv, lib, fetchurl, fetchzip, autoPatchelfHook, dpkg, awscli }:
stdenv.mkDerivation rec {
  pname = "ssm-session-manager-plugin";
  version = "1.1.61.0";

  base_url = "https://s3.amazonaws.com/session-manager-downloads/plugin";

  src = if stdenv.isDarwin then
    fetchzip rec {
      name = "sessionmanager-bundle.zip";
      url = "${base_url}/${version}/mac/${name}";
      sha256 = "0i5kc9wkn3dv4jbkbmjqf4w581i2n2sfqi42gm3vq28i7dwf0axz";
    }
  else
    fetchurl {
      url = "${base_url}/${version}/ubuntu_64bit/session-manager-plugin.deb";
      sha256 = "0z59irrpwhjjhn379454xyraqs590hij2n6n6k25w5hh8ak7imfl";
    };

  nativeBuildInputs = stdenv.lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [ awscli ];

  unpackPhase = stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
    dpkg-deb -x $src .
  '';

  installPhase = if stdenv.isDarwin then ''
    ./install -i $out -b $out/bin/${pname}
    addToSearchPath _PATH $out/bin
  '' else ''
    install -m755 -D usr/local/sessionmanagerplugin/bin/session-manager-plugin $out/bin/session-manager-plugin
  '';

  meta = with lib; {
    homepage =
      "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.unfree;
    changelog = "https://docs.aws.amazon.com/systems-manager/${version}/userguide/session-manager-working-with-install-plugin.html#plugin-version-history";
    maintainers = with maintainers; [ mbaillie ];
  };
}
