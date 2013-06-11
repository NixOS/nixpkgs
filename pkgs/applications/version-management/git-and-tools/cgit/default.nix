{ stdenv, fetchurl, openssl, zlib, asciidoc, libxml2, libxslt, docbook_xml_xslt }:

stdenv.mkDerivation rec {
  name = "cgit-0.9.2";

  src = fetchurl {
    url = "http://git.zx2c4.com/cgit/snapshot/${name}.tar.xz";
    sha256 = "0q177q1r7ssna32c760l4dx6p4aaz6kdv27zn2jb34bx98045h08";
  };

  # cgit is is tightly coupled with git and needs a git source tree to build.
  # The cgit-0.9.2 Makefile has GIT_VER = 1.8.3, so use that version.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump.
  gitSrc = fetchurl {
    url = https://git-core.googlecode.com/files/git-1.8.3.tar.gz;
    sha256 = "0fn5xdx30dl8dl1cdpqif5hgc3qnxlqfpwyhm0sm1wgqhgbcdlzi";
  };

  buildInputs = [ openssl zlib asciidoc libxml2 libxslt docbook_xml_xslt ];

  # Give cgit a git source tree and pass configuration parameters (as make
  # variables).
  preBuild = ''
    mkdir -p git
    tar --strip-components=1 -xf "$gitSrc" -C git

    makeFlagsArray+=(prefix="$out" CGIT_SCRIPT_PATH="$out/cgit/")
  '';

  # Install manpage.
  postInstall = ''
    # xmllint fails:
    #make install-man

    # bypassing xmllint works:
    a2x --no-xmllint -f manpage cgitrc.5.txt
    mkdir -p "$out/share/man/man5"
    cp cgitrc.5 "$out/share/man/man5"
  '';

  meta = {
    homepage = http://git.zx2c4.com/cgit/about/;
    description = "Web frontend for git repositories";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
