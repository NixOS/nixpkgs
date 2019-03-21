{ stdenv, lib, dpkg, fetchurl, gtk2, jre, libXtst, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xmind-${version}";
  version = "7.5-update1";

  src = if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
    url = "http://dl2.xmind.net/xmind-downloads/${name}-linux_i386.deb";
    sha256 = "04kr6pw0kwy715bp9wcnqnw1k5wl65xa87lhljrskm291p402jy1";
  } else if stdenv.hostPlatform.system == "x86_64-linux" then fetchurl {
    url = "http://dl2.xmind.net/xmind-downloads/${name}-linux_amd64.deb";
    sha256 = "1j2ynhk7p3m3vd6c4mjwpnlzqgfj5c4q3zydab3nfwncwx6gaqj9";
  } else throw "platform ${stdenv.hostPlatform.system} not supported!";

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  libPath = lib.makeLibraryPath [ gtk2 libXtst ];

  installPhase = ''
    mkdir -p $out
    cp -r usr/lib/xmind $out/libexec
    cp -r usr/bin usr/share $out
    rm $out/libexec/XMind.ini
    mv etc/XMind.ini $out/libexec

    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      $out/libexec/XMind

    wrapProgram $out/libexec/XMind \
      --prefix LD_LIBRARY_PATH : "${libPath}"

    substituteInPlace "$out/bin/XMind" \
       --replace '/usr/lib/xmind' "$out/libexec"

    ln -s ${jre} $out/libexec/jre
  '';

  meta = with stdenv.lib; {
    description = "Mind-mapping software";
    longDescription = ''
      XMind is a mind mapping and brainstorming software. In addition
      to the management elements, the software can capture ideas,
      clarify thinking, manage complex information, and promote team
      collaboration for higher productivity.

      It supports mind maps, fishbone diagrams, tree diagrams,
      organization charts, spreadsheets, etc. Normally, it is used for
      knowledge management, meeting minutes, task management, and
      GTD. Meanwhile, XMind can read FreeMind and MindManager files,
      and save to Evernote.
    '';
    homepage = http://www.xmind.net/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michalrus ];
  };
}
