{ appimageTools, fetchurl, lib, runCommandNoCC, stdenv, gsettings-desktop-schemas, gtk3, zlib }:

let
  name = "${pname}-${version}";
  pname = "minetime";
  version = "1.7.3";
  appimage = fetchurl {
    url = "https://github.com/marcoancona/MineTime/releases/download/v${version}/${name}.AppImage";
    sha256 = "0zz6p3mwxg9gm1sqzs582pq2nkb10lv0c3r542b9llqyzk9qv5aa";
  };
  extracted = appimageTools.extractType2 {
    inherit name;
    src = appimage;
  };
  patched = runCommandNoCC "minetime-patchelf" {} ''
    cp -av ${extracted} $out

    x=$out/resources/app.asar.unpacked/services/scheduling/dist/MinetimeSchedulingService
    chmod +w $x

    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --replace-needed libz.so.1 ${zlib}/lib/libz.so.1 \
      $x
  '';
in
appimageTools.wrapAppImage rec {
  inherit name;
  src = patched;

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = ps:
    appimageTools.defaultFhsEnvArgs.multiPkgs ps
    ++ (with ps; [ at-spi2-core at-spi2-atk libsecret libnotify ]);
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Modern, intuitive and smart calendar application";
    homepage = https://minetime.ai;
    license = licenses.unfree;
    # Should be cross-platform, but for now we just grab the appimage
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
