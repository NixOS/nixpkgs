{ aspell, aspellDicts_de, aspellDicts_en, buildEnv, fetchurl, fortune, gnugrep, makeWrapper, stdenv, tk, tre }:
let
  aspellEnv = buildEnv {
    name = "env-ding-aspell";
    paths = [
      aspell
      aspellDicts_de
      aspellDicts_en
    ];
  };
in
stdenv.mkDerivation rec {
  name = "ding-1.8";

  src = fetchurl {
    url = "http://ftp.tu-chemnitz.de/pub/Local/urz/ding/${name}.tar.gz";
    sha256 = "00z97ndwmzsgig9q6y98y8nbxy76pyi9qyj5qfpbbck24gakpz5l";
  };

  buildInputs = [ aspellEnv fortune gnugrep makeWrapper tk tre ];

  patches = [ ./dict.patch ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/dict
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps

    for f in ding ding.1; do
      sed -i "s@/usr/share@$out/share@g" "$f"
    done

    sed -i "s@/usr/bin/fortune@fortune@g" ding

    cp ding $out/bin/
    cp de-en.txt $out/share/dict/
    cp ding.1 $out/share/man/man1/
    cp ding.png $out/share/pixmaps/
    cp ding.desktop $out/share/applications/

    wrapProgram $out/bin/ding --prefix PATH : ${gnugrep}/bin:${aspellEnv}/bin:${tk}/bin:${fortune}/bin --prefix ASPELL_CONF : "\"prefix ${aspellEnv};\""
  '';

  meta = {
    description = "Simple and fast dictionary lookup tool";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ exi ];
  };
}
