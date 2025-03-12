{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation rec {
  version = "4.1.3";
  pname = "kpcli";

  src = fetchurl {
    url = "mirror://sourceforge/kpcli/${pname}-${version}.pl";
    hash = "sha256-yRNj5OB/NSGoZ/aNtgLJW1PcFn5DZu5/8lQlK0F2xi8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp ${src} $out/share/kpcli.pl
    chmod +x $out/share/kpcli.pl

    makeWrapper $out/share/kpcli.pl $out/bin/kpcli --set PERL5LIB \
      "${
        with perlPackages;
        makePerlPath (
          [
            BHooksEndOfScope
            CaptureTiny
            Clipboard
            Clone
            CryptRijndael
            CryptX
            DevelGlobalDestruction
            ModuleImplementation
            ModuleRuntime
            SortNaturally
            SubExporterProgressive
            TermReadKey
            TermShellUI
            TryTiny
            FileKDBX
            FileKeePass
            PackageStash
            RefUtil
            TermReadLineGnu
            XMLParser
            boolean
            namespaceclean
          ]
          ++ lib.optional stdenv.hostPlatform.isDarwin MacPasteboard
        )
      }"
  '';

  meta = with lib; {
    description = "KeePass Command Line Interface";
    mainProgram = "kpcli";
    longDescription = ''
      KeePass Command Line Interface (CLI) / interactive shell.
      Use this program to access and manage your KeePass 1.x or 2.x databases from a Unix-like command line.
    '';
    license = licenses.artistic1;
    homepage = "http://kpcli.sourceforge.net";
    platforms = platforms.all;
    maintainers = [ maintainers.j-keck ];
  };
}
