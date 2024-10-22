{ stdenv
, fetchurl
, lib
, autoPatchelfHook
}:

let
  version = "2024.1.2661979";

  # Upstream replaces minor versions, so use cached URLs.
  srcs = {
    "aarch64-linux" = fetchurl {
      url = "https://github.com/impl/nix-p4-archive/releases/download/p4d-${version}/helix-core-server-${version}-linux26aarch64.tgz";
      hash = "sha256-LBTUO3hElgNWeDDFX9GF6Me4ZHwoGsjgdrRJMeqPpnw=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/impl/nix-p4-archive/releases/download/p4d-${version}/helix-core-server-${version}-linux26x86_64.tgz";
      hash = "sha256-m8Qsbx5JDsiahKpcbXRzK6BCT+AyGnrf8xeUBMbb6Ic=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/impl/nix-p4-archive/releases/download/p4d-${version}/helix-core-server-${version}-macosx12arm64.tgz";
      hash = "sha256-rZ5Za/Cb/O6no49hWD256G6vTINgNVU0KqcLvujYFAw=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/impl/nix-p4-archive/releases/download/p4d-${version}/helix-core-server-${version}-macosx1015x86_64.tgz";
      hash = "sha256-/BmXiGRVzZBf25ra8rB2DXV/bArrfXOY5BCdHK2DDbE=";
    };
  };
in
stdenv.mkDerivation {
  pname = "p4d";
  inherit version;

  src =
    assert lib.assertMsg (builtins.hasAttr stdenv.hostPlatform.system srcs) "p4d is not available for ${stdenv.hostPlatform.system}";
    srcs.${stdenv.hostPlatform.system};

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontBuild = true;

  # Unnecessary, and seems to segfault on aarch64-darwin.
  dontStrip = true;

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
