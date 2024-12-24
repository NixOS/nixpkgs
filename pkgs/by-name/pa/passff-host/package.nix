{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pass,
}:

stdenv.mkDerivation rec {
  pname = "passff-host";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "passff";
    repo = pname;
    rev = version;
    sha256 = "sha256-P5h0B5ilwp3OVyDHIOQ23Zv4eLjN4jFkdZF293FQnNE=";
  };

  buildInputs = [ python3 ];
  makeFlags = [ "VERSION=${version}" ];

  patchPhase = ''
    sed -i 's#COMMAND = "pass"#COMMAND = "${pass}/bin/pass"#' src/passff.py
  '';

  installPhase = ''
    substituteInPlace bin/${version}/passff.json \
      --replace PLACEHOLDER $out/share/passff-host/passff.py

    install -Dt $out/share/passff-host \
      bin/${version}/passff.{py,json}

    nativeMessagingPaths=(
      /lib/mozilla/native-messaging-hosts
      /etc/opt/chrome/native-messaging-hosts
      /etc/chromium/native-messaging-hosts
      /etc/vivaldi/native-messaging-hosts
      /lib/librewolf/native-messaging-hosts
    )

    for manifestDir in "''${nativeMessagingPaths[@]}"; do
      install -d $out$manifestDir
      ln -s $out/share/passff-host/passff.json $out$manifestDir/
    done
  '';

  meta = with lib; {
    description = "Host app for the WebExtension PassFF";
    homepage = "https://github.com/passff/passff-host";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
