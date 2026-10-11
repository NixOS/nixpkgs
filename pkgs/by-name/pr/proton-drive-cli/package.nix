{
  lib,
  fetchurl,
  buildFHSEnv,
  pkgs,
  stdenv,
}:

let
  version = "0.7.0";
  pname = "proton-drive";
  system = "linux-x64";

  protonSource = fetchurl {
    url = "https://proton.me/download/drive/cli/${version}/${system}/${pname}";
    hash = "sha256-Tjx0p6JdoA16DKnuIjqbewsjjaNXq2/P7gSlwxPd9NE=";
  };

  protonBinary = stdenv.mkDerivation {
    name = "proton-drive-cli-binary";
    src = protonSource;

    dontUnpack = true;
    dontStrip = true;
    dontPatchELF = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/proton-drive-cli
      chmod +x $out/bin/proton-drive-cli
    '';
  };
in
buildFHSEnv {
  name = "proton-drive-cli";

  targetPkgs =
    p: with p; [
      stdenv.cc.cc.lib
      zlib
      libsecret
      glib
      dbus
      pkg-config
    ];

  runScript = toString (
    pkgs.writeScript "proton-drive-cli-wrapper" ''
      exec ${protonBinary}/bin/proton-drive-cli "$@"
    ''
  );

  meta = with lib; {
    description = "Proton Drive Command Line Interface";
    homepage = "https://proton.me/download/drive/cli";
    license = licenses.unfree;
    maintainers = "TylerNilson";
    platforms = [ "x86_64-linux" ];
  };
}
