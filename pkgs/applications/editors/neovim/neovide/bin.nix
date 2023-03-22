{ lib
, stdenvNoCC
, fetchurl
, undmg
, unzip
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "neovide-bin";
  version = "0.10.3";

  src = fetchurl {
    url = "https://github.com/neovide/neovide/releases/download/${version}/Neovide.dmg.zip";
    sha256 = "sha256-+oupgom7NpUb1q4Uok7EE3zs7Ji8sWtXdvWCCtfIVFk=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ makeWrapper unzip undmg ];

  sourceRoot = "Neovide.app";

  unpackPhase = ''
    runHook preUnpack

    ${unzip}/bin/unzip $src -d $TMPDIR
    /usr/bin/hdiutil mount $TMPDIR/Neovide.dmg
    cp -R /Volumes/Neovide/Neovide.app .
    /usr/bin/hdiutil unmount /Volumes/Neovide
    rm -r $TMPDIR/Neovide.dmg

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications/Neovide.app,bin}
    cp -R . $out/Applications/Neovide.app
    makeWrapper $out/Applications/Neovide.app/Contents/MacOS/neovide $out/bin/neovide

    runHook postInstall
  '';

  meta = with lib; {
    description = "No Nonsense Neovim Client in Rust";
    homepage = "https://neovide.dev";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ stepbrobd ];
    mainProgram = "neovide";
    platforms = platforms.darwin;
  };
}
