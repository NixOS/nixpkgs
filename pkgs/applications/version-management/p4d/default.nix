{ stdenv
, fetchurl
, lib
, autoPatchelfHook
}:

let
  # Upstream replaces minor versions, so use cached URLs.
  srcs = {
    "i686-linux" = fetchurl {
      url = "https://web.archive.org/web/20220907001049/https://ftp.perforce.com/perforce/r22.1/bin.linux26x86/helix-core-server.tgz";
      sha256 = "e9cf27c9dd2fa6432745058a93896d151543aff712fce9f7322152d6ea88a12a";
    };
    "x86_64-linux" = fetchurl {
      url = "https://web.archive.org/web/20220907001202/https://ftp.perforce.com/perforce/r22.1/bin.linux26x86_64/helix-core-server.tgz";
      sha256 = "9c272b67574264a4f49fe846ccda24fbd4baeb282665af74b6fbccff26a43558";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://web.archive.org/web/20220907001334/https://ftp.perforce.com/perforce/r22.1/bin.macosx1015x86_64/helix-core-server.tgz";
      sha256 = "2500a23fe482a303bd400f0de460b7624ad3f940fef45246004b9f956e90ea45";
    };
  };
in
stdenv.mkDerivation {
  pname = "p4d";
  version = "2022.1.2305383";

  src =
    assert lib.assertMsg (builtins.hasAttr stdenv.hostPlatform.system srcs) "p4d is not available for ${stdenv.hostPlatform.system}";
    srcs.${stdenv.hostPlatform.system};

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dontBuild = true;

  installPhase = ''
    install -D -t $out/bin p4broker p4d p4p
    install -D -t $out/doc/p4d -m 0644 *.txt
  '';

  meta = with lib; {
    description = "Perforce Helix Core Server";
    homepage = "https://www.perforce.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "p4d";
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ impl ];
  };
}
