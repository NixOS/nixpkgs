{
  lib,
  stdenv,
  fetchurl,
  runtimeShell,
  makeWrapper,
  oraclejre,
  antialiasFont ? true,
}:

stdenv.mkDerivation {
  pname = "docear";
  version = "1.2";

  src = fetchurl {
    url = "http://docear.org/downloads/docear_linux.tar.gz";
    sha256 = "1g5n7r2x4gas6dl2fbyh7v9yxdcb6bzml8n3ldmpzv1rncgjcdp4";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ oraclejre ];

  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp -R * $out/share
    chmod 0755 $out/share/ -R

    # The wrapper ensures oraclejre is used
    makeWrapper ${runtimeShell} $out/bin/docear \
      --set _JAVA_OPTIONS "${lib.optionalString antialiasFont "-Dswing.aatext=TRUE -Dawt.useSystemAAFontSettings=on"}" \
      --set JAVA_HOME ${oraclejre.home} \
      --add-flags "$out/share/docear.sh"

    chmod 0755 $out/bin/docear
  '';

  meta = with lib; {
    description = "A unique solution to academic literature management";
    homepage = "http://www.docear.org/";
    # Licenses at: http://www.docear.org/software/download/
    license = with licenses; [
      gpl2 # for the main software and some dependencies
      bsd3 # for one of its dependencies
    ];
    maintainers = with maintainers; [ unode ];
    platforms = platforms.all;
  };
}
