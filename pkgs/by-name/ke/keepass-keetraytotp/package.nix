{
  lib,
  stdenv,
  buildEnv,
  fetchurl,
  mono,
}:

let
  version = "0.108.0";

  drv = stdenv.mkDerivation {
    pname = "keepass-keetraytotp";
    inherit version;

    src = fetchurl {
      url = "https://github.com/KeeTrayTOTP/KeeTrayTOTP/releases/download/v${version}/KeeTrayTOTP.plgx";
      sha256 = "4f7251a9bbb79cad04aee96d1809c6b36d43285a9f3834fef5330fc97ae8bc09";
    };

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $src $out/lib/dotnet/keepass/
    '';

    meta = with lib; {
      description = "Augments KeePass with TOTP user interface";
      longDescription = ''
        This KeePass2 plugin adds advanced support for generating Time-based One-Time Passwords (TOTPs)
        from the KeePass tray icon. It also provides a column in the main entry list to display and/or use TOTPs.
        TOTPs can also be sent by auto-type. The plugin is compatible with Google, Dropbox, Steam, and many more services.
      '';
      homepage = "https://github.com/KeeTrayTOTP/KeeTrayTOTP";
      platforms = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];
      license = licenses.gpl3;
      maintainers = with maintainers; [ nazarewk ];
    };
  };
in
# Mono is required to compile plugin at runtime, after loading.
buildEnv {
  name = drv.name;
  paths = [
    mono
    drv
  ];
}
