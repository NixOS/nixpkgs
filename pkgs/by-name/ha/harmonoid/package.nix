{
  lib,
  stdenv,
  fetchurl,
  undmg,
  autoPatchelfHook,
  makeWrapper,
  cairo,
  gdk-pixbuf,
  gtk3,
  libz,
  pango,
  harfbuzz,
  atkmm,
  libcxx,
  mpv-unwrapped,
}:
let
  version = "0.3.10";
  url_base = "https://github.com/alexmercerind2/harmonoid-releases/releases/download/v${version}";
  url =
    rec {
      x86_64-linux = "${url_base}/harmonoid-linux-x86_64.tar.gz";
      x86_64-darwin = "${url_base}/harmonoid-macos-universal.dmg";
      aarch64-darwin = x86_64-darwin;
    }
    .${stdenv.hostPlatform.system}
      or (throw "${stdenv.hostPlatform.system} is an unsupported platform");
  hash =
    rec {
      x86_64-linux = "sha256-GTF9KrcTolCc1w/WT0flwlBCBitskFPaJuNUdxCW9gs=";
      x86_64-darwin = "sha256-7qcUnYBasUqisEW56fq4JGgojBmfqycrDIMpCCWLxlc=";
      aarch64-darwin = x86_64-darwin;
    }
    .${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "harmonoid";
  inherit version;

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    undmg
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    cairo
    gdk-pixbuf
    gtk3
    libz
    pango
    harfbuzz
    atkmm
    libcxx
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out
    cp -r bin $out
    mkdir -p $out
    cp -r share $out
    wrapProgram $out/bin/harmonoid --prefix LD_LIBRARY_PATH : $out/share/harmonoid/lib:${
      lib.makeLibraryPath [ mpv-unwrapped ]
    }
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r . $out/Applications/Harmonoid.app
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "Plays & manages your music library";
    homepage = "https://harmonoid.com/";
    changelog = "https://github.com/harmonoid/harmonoid/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ivyfanchiang ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    license = {
      fullName = "PolyForm Strict License 1.0.0";
      url = "https://polyformproject.org/licenses/strict/1.0.0/";
      free = false;
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
