{ stdenv, lib
, makeWrapper, dpkg, fetchurl, autoPatchelfHook
, curl, kerberos, lttng-ust, libpulseaudio, gtk3, openssl_1_1, icu, webkitgtk, librsvg, gdk-pixbuf, libsoup, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "aws-workspaces";
  version = "3.1.3.925";

  src = fetchurl {
    # ref https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/bionic/main/binary-amd64/Packages
    urls = [
      "https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/bionic/main/binary-amd64/workspacesclient_${version}_amd64.deb"
      "https://web.archive.org/web/20210307233836/https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/bionic/main/binary-amd64/workspacesclient_${version}_amd64.deb"
    ];
    sha256 = "5b57edb4f6f8c950164fd8104bf62df4c452ab5b16cb65d48db3636959a0f0ad";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # Crashes at startup when stripping:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  buildInputs = [
    stdenv.cc.cc.lib
    kerberos
    curl
    lttng-ust
    libpulseaudio
    gtk3
    openssl_1_1.out
    icu
    webkitgtk
    librsvg
    gdk-pixbuf
    libsoup
    glib-networking
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $out/opt/workspacesclient/* $out/bin

    wrapProgram $out/bin/workspacesclient \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --set GIO_EXTRA_MODULES "${glib-networking.out}/lib/gio/modules"
  '';

  meta = with lib; {
    description = "Client for Amazon WorkSpaces, a managed, secure Desktop-as-a-Service (DaaS) solution";
    homepage = "https://clients.amazonworkspaces.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ]; # TODO Mac support
    maintainers = [ maintainers.mausch ];
  };
}
