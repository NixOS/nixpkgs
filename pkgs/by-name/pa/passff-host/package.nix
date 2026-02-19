{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passff-host";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "passff";
    repo = "passff-host";
    rev = finalAttrs.version;
    sha256 = "sha256-P5h0B5ilwp3OVyDHIOQ23Zv4eLjN4jFkdZF293FQnNE=";
  };

  buildInputs = [ python3 ];
  makeFlags = [ "VERSION=${finalAttrs.version}" ];

  patchPhase = ''
    sed -i 's#COMMAND = "pass"#COMMAND = "${pass}/bin/pass"#' src/passff.py
  '';

  installPhase = ''
    substituteInPlace bin/${finalAttrs.version}/passff.json \
      --replace PLACEHOLDER $out/share/passff-host/passff.py

    install -Dt $out/share/passff-host \
      bin/${finalAttrs.version}/passff.{py,json}

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

  meta = {
    description = "Host app for the WebExtension PassFF";
    homepage = "https://github.com/passff/passff-host";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
