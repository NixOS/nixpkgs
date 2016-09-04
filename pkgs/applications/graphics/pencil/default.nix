{ stdenv, fetchurl, makeWrapper, xulrunner }:

stdenv.mkDerivation rec {
  version = "2.0.18";
  name = "pencil-${version}";

  src = fetchurl {
    url = "https://github.com/prikhi/pencil/releases/download/v${version}/Pencil-${version}-linux-pkg.tar.gz";
    sha256 = "0x0kibb2na12fwl0x68xhkjpbm5h2widm346cx2r29gp1kq9kklc";
  };

  buildPhase = "";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out"
    cp -r usr/* "$out"
    sed -e "s|/usr/share/evolus-pencil|$out/share/evolus-pencil|" \
        -i "$out/bin/pencil"
    sed -e "s|/usr/bin/pencil|$out/bin/pencil|" \
        -e "s|Icon=.*|Icon=$out/share/evolus-pencil/skin/classic/icon.svg|" \
        -i "$out/share/applications/pencil.desktop"

    wrapProgram $out/bin/pencil \
      --prefix PATH ":" ${xulrunner}/bin
  '';

  meta = with stdenv.lib; {
    description = "GUI prototyping/mockup tool";
    homepage = http://github.com/prikhi/pencil;
    license = licenses.gpl2; # Commercial license is also available
    maintainers = with maintainers; [ bjornfor prikhi ];
    platforms = platforms.linux;
    # See https://github.com/prikhi/pencil/issues/840
    # ("Error: Platform version '47.0' is not compatible with minVersion >= 36.0 maxVersion <= 46.*")
    broken = true;
  };
}
