{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "smack";
  version = "4.1.9";

  src = fetchurl {
    url = "http://www.igniterealtime.org/downloadServlet?filename=smack/smack_${
      lib.replaceStrings [ "." ] [ "_" ] version
    }.tar.gz";
    sha256 = "009x0qcxd4dkvwcjz2nla470pwbabwvg37wc21pslpw42ldi0bzp";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp libs/smack-*.jar $out/share/java

    runHook postInstall
  '';

  meta = {
    description = "XMPP (Jabber) client library for instant messaging and presence";
    homepage = "http://www.igniterealtime.org/projects/smack/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
}
