{ stdenv, pkgs, fetchurl, lib, makeWrapper, gvfs, atomEnv}:

stdenv.mkDerivation rec {
  name = "atom-beta-${version}";
  version = "1.22.0-beta0";

  src = fetchurl {
    url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
    sha256 = "0xsj0vvaxjw60gg6niaws2lf9lkrh1sz7ypk41g6l4hdgmqyg6fi";
    name = "${name}.deb";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/usr/
    ar p $src data.tar.xz | tar -C $out -xJ ./usr
    substituteInPlace $out/usr/share/applications/atom-beta.desktop \
      --replace /usr/share/atom-beta $out/bin
    mv $out/usr/* $out/
    rm -r $out/share/lintian
    rm -r $out/usr/
    sed -i "s/'atom-beta'/'.atom-beta-wrapped'/" $out/bin/atom-beta
    wrapProgram $out/bin/atom-beta \
      --prefix "PATH" : "${gvfs}/bin"

    fixupPhase

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}:$out/share/atom-beta" \
      $out/share/atom-beta/atom
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}" \
      $out/share/atom-beta/resources/app/apm/bin/node

    #rm -f $out/share/atom-beta/resources/app/node_modules/dugite/git/bin/git
    #ln -s ${pkgs.git}/bin/git $out/share/atom-beta/resources/app/node_modules/dugite/git/bin/git

    find $out/share/atom-beta -name "*.node" -exec patchelf --set-rpath "${atomEnv.libPath}:$out/share/atom-beta" {} \;

    paxmark m $out/share/atom-beta/atom
    paxmark m $out/share/atom-beta/resources/app/apm/bin/node
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = licenses.mit;
    maintainers = [ maintainers.offline maintainers.nequissimus ];
    platforms = [ "x86_64-linux" ];
  };
}
