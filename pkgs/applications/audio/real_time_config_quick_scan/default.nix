{ stdenv, fetchFromGitHub, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "realTimeConfigQuickScan";
  version = "unstable-2020-08-03";

  src = fetchFromGitHub {
    owner  = "raboof";
    repo   = pname;
    rev    = "4b482db17f8d8567ba0abf33459ceb5f756f088c";
    sha256 = "00l69gzwla9gjv5kpklgxlwnl48wnh8h6w0k8i69qr2cxigg4rhj";
  };

  buildInputs = [ perlPackages.perl makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/doc
    # Install Script Files:
    # *.pm files
    for i in *.pm; do
    install -Dm 755 "$i" "$out/share/$i"
    done
    # Install doc files:
    install -D COPYING  "$out/share/doc/COPYING"
    install -D README.md  "$out/share/doc/README.md"
    # Install Executable scripts:
    install -Dm 755 realTimeConfigQuickScan.pl "$out/bin/realTimeConfigQuickScan"
    install -Dm 755 QuickScan.pl "$out/bin/QuickScan"
    wrapProgram $out/bin/realTimeConfigQuickScan \
      --set PERL5LIB "$out/share"
    wrapProgram $out/bin/QuickScan \
      --set PERL5LIB "$out/share:${with perlPackages; makePerlPath [ Tk ]}"
  '';
  meta = with stdenv.lib; {
    description = "Linux configuration checker for systems to be used for real-time audio";
    homepage = "https://github.com/raboof/realtimeconfigquickscan";
    license = licenses.gpl2;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux ;
  };
}

