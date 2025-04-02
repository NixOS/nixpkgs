{
  stdenv,
  lib,
  fetchurl,
  # needs to be jre8 due to https://github.com/openpnp/openpnp/issues/1361
  jre8,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "openpnp";
  version = "2.0";

  src = fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/openpnp/OpenPnP-unix-develop.tar.gz";
    hash = "sha256-PwBumcz2T+pMBQRmP22GBEwDbwsvxyMYGASSD2qz510=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/openpnp
    cp openpnp-gui-0.0.1-alpha-SNAPSHOT.jar $out/libexec/openpnp/
    cp lib/*.jar $out/libexec/openpnp/

    mkdir -p $out/bin
    makeWrapper ${jre8}/bin/java $out/bin/openpnp \
      --add-flags "-cp $out/libexec/openpnp/\* org.openpnp.Main"
  '';

  meta = with lib; {
    description = "Open Source SMT pick and place system";
    homepage = "https://openpnp.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.flokli ];
    platforms = platforms.linux;
  };
}
