{ stdenv, fetchFromGitHub, wmctrl, pythonPackages, byzanz, xdpyinfo, makeWrapper, gtk, xorg }:

let
  rev = "73ad00d937ff62aa6eac70a1fa352ec50790bbd8";
in stdenv.mkDerivation rec {
  name = "mkcast-${rev}";

  src = fetchFromGitHub {
    owner = "KeyboardFire";
    repo = "mkcast";
    inherit rev;
    sha256 = "0g1q87p6flpjh4xl2zqmb5n08zlwcm3pvk08pva4glmnnayplncb";
  };

  buildInputs = with pythonPackages; [ makeWrapper pygtk gtk xlib ];

  installPhase = ''
    sed -i 's/2>&1//' mkcast
    sed -i 's@2> /dev/null@@' mkcast
    sed -i 's@screenkey/screenkey@../screenkey/screenkey@' mkcast
    install -Dm 755 mkcast $out/bin/mkcast
    install -Dm 755 newcast $out/bin/newcast
    cp -R screenkey $out/

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : "${xdpyinfo}/bin:${wmctrl}/bin/:${byzanz}/bin/:$out/bin"
    done

    wrapProgram $out/screenkey/screenkey --prefix PATH : "${xorg.xmodmap}/bin"\
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';
}
