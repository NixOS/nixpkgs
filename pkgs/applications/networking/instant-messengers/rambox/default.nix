{ stdenv, fetchurl, xdg_utils, dpkg, makeWrapper, autoPatchelfHook
, libXtst, libXScrnSaver, gtk3, nss, alsaLib, udev, libnotify
}:

let
  version = "0.7.4";
in stdenv.mkDerivation rec {
  pname = "rambox";
  inherit version;
  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/ramboxapp/community-edition/releases/download/${version}/Rambox-${version}-linux-amd64.deb";
      sha256 = "0m9627bcwfg9aximv7ifsmspm8xi231pcnnd4p46lahb2qp19vbd";
    };
    i686-linux = fetchurl {
      url = "https://github.com/ramboxapp/community-edition/releases/download/${version}/Rambox-${version}-linux-i386.deb";
      sha256 = "162p6x400w3pny38adinp53rcifvbkjbs12cwrpf7s3b0yml8qxr";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook ];
  buildInputs = [ libXtst libXScrnSaver gtk3 nss alsaLib ];
  runtimeDependencies = [ udev.lib libnotify ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Rambox/rambox $out/bin

    # provide resources
    cp -r usr/share $out
    substituteInPlace $out/share/applications/rambox.desktop \
      --replace Exec=/opt/Rambox/rambox Exec=rambox
  '';

  postFixup = ''
    wrapProgram $out/opt/Rambox/rambox --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "Free and Open Source messaging and emailing app that combines common web applications into one";
    homepage = http://rambox.pro;
    license = licenses.mit;
    maintainers = with maintainers; [ gnidorah ma27 ];
    platforms = ["i686-linux" "x86_64-linux"];
    hydraPlatforms = [];
  };
}
