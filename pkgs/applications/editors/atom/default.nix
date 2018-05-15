{ stdenv, pkgs, fetchurl, lib, makeWrapper, gvfs, atomEnv}:

stdenv.mkDerivation rec {
  name = "atom-${version}";
  version = "1.26.1";

  src = fetchurl {
    url = "https://github.com/atom/atom/releases/download/v${version}/atom-amd64.deb";
    sha256 = "0g83qj9siq1vr2v46rzjf3dy2gns9krh6xlh7w3bhrgfk0vqkm11";
    name = "${name}.deb";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/usr/
    ar p $src data.tar.xz | tar -C $out -xJ ./usr
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

    rm -f $out/share/atom/resources/app.asar.unpacked/node_modules/dugite/git/bin/git
    ln -s ${pkgs.git}/bin/git $out/share/atom/resources/app.asar.unpacked/node_modules/dugite/git/bin/git
    rm -f $out/share/atom/resources/app.asar.unpacked/node_modules/dugite/git/libexec/git-core/git
    ln -s ${pkgs.git}/bin/git $out/share/atom/resources/app.asar.unpacked/node_modules/dugite/git/libexec/git-core/git

    find $out/share/atom -name "*.node" -exec patchelf --set-rpath "${atomEnv.libPath}:$out/share/atom" {} \;

    paxmark m $out/share/atom/atom
    paxmark m $out/share/atom/resources/app/apm/bin/node
  '';

  meta = with stdenv.lib; {
    description = "A hackable text editor for the 21st Century";
    homepage = https://atom.io/;
    license = licenses.mit;
    maintainers = [ maintainers.offline maintainers.nequissimus maintainers.ysndr ];
    platforms = [ "x86_64-linux" ];
  };
}
