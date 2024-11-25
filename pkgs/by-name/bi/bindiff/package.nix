{
  buildFHSEnv,
  fetchurl,
  dpkg,
  makeWrapper,
  lib,
  stdenv,
  jdk17,
  fontconfig,
  makeDesktopItem,
}:
let
  version = "8";
  meta = {
    description = "Quickly find differences and similarities in disassembled code";
    homepage = "https://zynamics.com/bindiff.html";
    changelog = "https://github.com/google/bindiff/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.BonusPlay ];
  };
  desktopItem = makeDesktopItem {
    name = "bindiff";
    exec = "bindiff";
    comment = meta.description;
    desktopName = "BinDiff";
    genericName = "BinDiff";
    categories = [ "Development" ];
    icon = "com-google-security-zynamics-bindiff";
  };
  pkg = stdenv.mkDerivation {
    src = fetchurl {
      url = "https://github.com/google/bindiff/releases/download/v${version}/bindiff_${version}_amd64.deb";
      sha256 = "sha256-ghmQ45dKnfZzN5Q3DkhUhqwna6XXd6BrTr5XXwkvTdo=";
    };
    inherit version;
    pname = "bindiff";

    nativeBuildInputs = [
      makeWrapper
      dpkg
    ];

    dontBuild = true;

    unpackPhase = ''
      dpkg-deb -x "$src" ./
    '';

    installPhase = ''
      mkdir -p "$out/usr" "$out/opt"
      cp -a usr/* "$out/usr"
      cp -a opt/* "$out/opt"
      cp -a etc/* "$out/etc"
    '';

    postFixup = ''
      wrapProgram $out/opt/bindiff/bin/bindiff \
        --set JAVA_HOME ${jdk17.home} \
        --chdir /opt/bindiff

      wrapProgram $out/opt/bindiff/bin/bindiff_ui \
        --set JAVA_HOME ${jdk17.home} \
        --set FONTCONFIG_FILE ${fontconfig.out}/etc/fonts/fonts.conf \
        --chdir /opt/bindiff
    '';

    inherit desktopItem;
    inherit meta;
  };
in
buildFHSEnv {
  name = "bindiff";
  targetPkgs = pkgs: [ pkg ];
  runScript = "${pkg}/opt/bindiff/bin/bindiff";
}
// {
  inherit (pkg) meta name;
}
