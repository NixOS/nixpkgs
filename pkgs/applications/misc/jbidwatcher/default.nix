{ stdenv, fetchurl, java }:

stdenv.mkDerivation rec {
  pname = "jbidwatcher";
  version = "2.5.2";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.jbidwatcher.com/download/JBidwatcher-${version}.jar";
    sha256 = "07w75ryn8inm5i1829gabr8lifbycz40ynzsyaw22yzqk5if1n9l";
  };

  buildInputs = [ java ];

  jarfile = "$out/share/java/${pname}/JBidwatcher.jar";

  unpackPhase = "true";

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    echo > "$out/bin/${pname}" "#!/bin/sh"
    echo >>"$out/bin/${pname}" "${java}/bin/java -Xmx512m -jar ${jarfile}"
    chmod +x "$out/bin/${pname}"
    install -D -m644 ${src} ${jarfile}
  '';

  meta = {
    homepage = "http://www.jbidwatcher.com/";
    description = "monitor and snipe Ebay auctions";
    license = "LGPL";

    longDescription = ''
      A Java-based application allowing you to monitor auctions you're
      not part of, submit bids, snipe (bid at the last moment), and
      otherwise track your auction-site experience. It includes
      adult-auction management, MANY currencies (pound, dollar (US,
      Canada, Australian, and New Taiwanese) and euro, presently),
      drag-and-drop of auction URLs, an original, unique and powerful
      'multisniping' feature, a relatively nice UI, and is known to work
      cleanly under Linux, Windows, Solaris, and MacOSX from the same
      binary.
    '';

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
