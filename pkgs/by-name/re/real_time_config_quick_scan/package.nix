{ lib, stdenv, fetchFromGitHub, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "realTimeConfigQuickScan";
  version = "unstable-2020-07-23";

  src = fetchFromGitHub {
    owner  = "raboof";
    repo   = pname;
    rev    = "4697ba093d43d512b74a73b89531cb8c5adaa274";
    sha256 = "16kanzp5i353x972zjkwgi3m8z90wc58613mlfzb0n01djdnm6k5";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/$pname
    mkdir -p $out/share/doc/$pname
    # Install Script Files:
    # *.pm files
    for i in *.pm; do
    install -Dm 755 "$i" "$out/share/$pname/$i"
    done
    # Install doc files:
    install -D COPYING  "$out/share/doc/$pname/COPYING"
    install -D README.md  "$out/share/doc/$pname/README.md"
    # Install Executable scripts:
    install -Dm 755 realTimeConfigQuickScan.pl "$out/bin/realTimeConfigQuickScan"
    install -Dm 755 QuickScan.pl "$out/bin/QuickScan"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/realTimeConfigQuickScan \
      --set PERL5LIB "$out/share/$pname"
    wrapProgram $out/bin/QuickScan \
      --set PERL5LIB "$out/share/$pname:${with perlPackages; makePerlPath [ Tk ]}"
  '';

  meta = with lib; {
    description = "Linux configuration checker for systems to be used for real-time audio";
    homepage = "https://github.com/raboof/realtimeconfigquickscan";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux ;
  };
}

