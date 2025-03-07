{ stdenv
, fetchurl
, lib
, autoPatchelfHook
}:

let
  # Upstream replaces minor versions, so use cached URLs.
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://web.archive.org/web/20231109221336id_/https://ftp.perforce.com/perforce/r23.1/bin.linux26x86_64/helix-core-server.tgz";
      sha256 = "b68c4907cf9258ab47102e8f0e489c11d528a8f614bfa45e3a2fa198639e2362";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://web.archive.org/web/20231109221937id_/https://ftp.perforce.com/perforce/r23.1/bin.macosx1015x86_64/helix-core-server.tgz";
      sha256 = "fcbf09787ffc29f7237839711447bf19a37ae18a8a7e19b2d30deb3715ae2c11";
    };
  };
in
stdenv.mkDerivation {
  pname = "p4d";
  version = "2023.1.2513900";

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
    maintainers = with maintainers; [ corngood impl ];
  };
}
