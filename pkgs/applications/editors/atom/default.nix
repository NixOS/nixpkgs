{ stdenv, fetchurl, lib, makeWrapper, gvfs, atomEnv}:

stdenv.mkDerivation rec {
  name = "atom-${version}";
  version = "1.16.0";

  src = fetchurl {
    url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
    sha256 = "10qzhfz34i7x7z5fv5a73a6aiwxvanyn0v825a6yz9qfc2mg4shd";
    name = "${name}.deb";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/usr/
    ar p $src data.tar.gz | tar -C $out -xz ./usr
    substituteInPlace $out/usr/share/applications/atom.desktop \
      --replace /usr/share/atom $out/bin
    mv $out/usr/* $out/
    rm -r $out/share/lintian
    rm -r $out/usr/
    wrapProgram $out/bin/atom \
      --prefix "PATH" : "${gvfs}/bin"

    fixupPhase

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}:$out/share/atom" \
      $out/share/atom/atom
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}" \
      $out/share/atom/resources/app/apm/bin/node

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/atom/resources/app.asar.unpacked/node_modules/symbols-view/vendor/ctags-linux

    find $out/share/atom -name "*.node" -exec patchelf --set-rpath "${atomEnv.libPath}:$out/share/atom" {} \;
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = licenses.mit;
    maintainers = [ maintainers.offline maintainers.nequissimus ];
    platforms = [ "x86_64-linux" ];
  };
}
