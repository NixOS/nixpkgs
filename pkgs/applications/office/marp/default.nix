{ stdenv, fetchurl, atomEnv, libXScrnSaver }:

stdenv.mkDerivation rec {
  name = "marp-${version}";
  version = "0.0.12";

  src = fetchurl {
    url = "https://github.com/yhatt/marp/releases/download/v${version}/${version}-Marp-linux-x64.tar.gz";
    sha256 = "0pljjkis9vb819d0akqmqnyakwgnvc3qqyg20yr13xms9a5iqv32";
  };
  sourceRoot = ".";

  installPhase = ''
      mkdir -p $out/lib/marp $out/bin
      cp -r ./* $out/lib/marp
      ln -s $out/lib/marp/Marp $out/bin
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}:${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}:$out/lib/marp" \
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
