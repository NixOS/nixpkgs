{ electron_9
, dpkg
, fetchurl
, glib
, gsettings-desktop-schemas
, gtk3
, lib
, makeWrapper
, stdenv
, wrapGAppsHook
, withPandoc ? true
, pandoc
, haskellPackages
, withLatex ? true
, texlive
,...}:

stdenv.mkDerivation rec {
  pname="zettlr";
  version="1.7.5";

  src = fetchurl {
    url="https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-amd64.deb";
    sha256="9e680742ba17fb9253350f35aec105307b7da309ce295d4f8360eaeba9e8a9bd";

  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
  ];


  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  dontWrapGApps = true;

  installPhase = ''
    set -x
    runHook preInstall
    ls >&2;
    mkdir -p $out/bin $out/share
    cp opt/Zettlr/resources/app.asar $out/share/zettlr.asar
    {
      cd usr
      cp -r share/{applications,icons,mime} $out/share/
    }
    sed -i '/^Exec=/s:.*:Exec='"$out"'/bin/zettlr %U:' $out/share/applications/zettlr.desktop
    runHook postInstall
    set +x
  '';

  postFixup = ''
    makeWrapper ${electron_9}/bin/electron $out/bin/zettlr \
      --add-flags $out/share/zettlr.asar ${
      lib.optionalString withPandoc ''\
        --prefix PATH : "${lib.makeBinPath [ pandoc haskellPackages.pandoc-citeproc ]}"''
      }${
      lib.optionalString withLatex ''\
        --prefix PATH : "${texlive.combined.scheme-medium}/bin"''
      }

  '';

  meta = with stdenv.lib; {
    homepage = "https://www.zettlr.com/";
    description = "A Markdown Editor for the 21st century.";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = [ maintainers.beardhatcode ];
  };

}
