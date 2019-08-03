{ stdenv, fetchurl, atomEnv, libXScrnSaver, gtk2 }:

stdenv.mkDerivation rec {
  name = "marp-${version}";
  version = "0.0.14";

  src = fetchurl {
    url = "https://github.com/yhatt/marp/releases/download/v${version}/${version}-Marp-linux-x64.tar.gz";
    sha256 = "0nklzxwdx5llzfwz1hl2jpp2kwz78w4y63h5l00fh6fv6zisw6j4";
  };

  unpackPhase = ''
    mkdir {locales,resources}
    tar --delay-directory-restore -xf $src
    chmod u+x {locales,resources}
  '';

  installPhase = ''
    mkdir -p $out/lib/marp $out/bin
    cp -r ./* $out/lib/marp
    ln -s $out/lib/marp/Marp $out/bin
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}:${stdenv.lib.makeLibraryPath [ libXScrnSaver gtk2 ]}:$out/lib/marp" \
      $out/bin/Marp
  '';

  meta = with stdenv.lib; {
    description = "Markdown presentation writer, powered by Electron";
    homepage = https://yhatt.github.io/marp/;
    license = licenses.mit;
    maintainers = [ maintainers.puffnfresh ];
    platforms = [ "x86_64-linux" ];
  };
}
