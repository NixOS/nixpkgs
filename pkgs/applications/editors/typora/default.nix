{ stdenv
, lib
, fetchurl
, makeWrapper
, electron_9
, dpkg
, gtk3
, glib
, gsettings-desktop-schemas
, wrapGAppsHook
, withPandoc ? false
, pandoc
}:

let
  electron = electron_9;
in
stdenv.mkDerivation rec {
  pname = "typora";
  version = "0.9.98";

  src = fetchurl {
    url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
    sha256 = "sha256-JiqjxT8ZGttrcJrcQmBoGPnRuuYWZ9u2083RxZoLMus=";
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

  # The deb contains setuid permission on `chrome-sandbox`, which will actually not get installed.
  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    {
      cd usr
      mv share/typora/resources/app $out/share/typora
      mv share/{applications,icons,doc} $out/share/
    }

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/typora \
      --add-flags $out/share/typora \
      "''${gappsWrapperArgs[@]}" \
      ${lib.optionalString withPandoc ''--prefix PATH : "${lib.makeBinPath [ pandoc ]}"''} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = "https://typora.io";
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin ];
    platforms = [ "x86_64-linux"];
  };
}
