{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, awscli, unzip }:
let
  ver = "1.2.331.0";
  source = {
    url = rec {
      "x86_64-linux" = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/ubuntu_64bit/session-manager-plugin.deb";
      "aarch64-linux" = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/ubuntu_arm64/session-manager-plugin.deb";
      "x86_64-darwin" = "https://s3.amazonaws.com/session-manager-downloads/plugin/${ver}/mac/sessionmanager-bundle.zip";
      "aarch64-darwin" = x86_64-darwin;
    }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    sha256 = rec {
      "x86_64-linux" = "sha256-xWnY89dslkGhRTh9llRFkuUqYIjHQNt+TLnkPQr3u1Q=";
      "aarch64-linux" = "sha256-QE6+EjLoydTPuLitG6fALXAtvIkfyoFuWij8Z2HT6+Q=";
      "x86_64-darwin" = "0gr6frdn9jvxnkymkcpvgkqw4z2sac9jdf5qj4hzakq1zkfviazf";
      "aarch64-darwin" = x86_64-darwin;
    }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
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
    homepage = "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "Amazon SSM Session Manager Plugin";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ mbaillie ];
  };
}
