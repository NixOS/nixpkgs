{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  nasm,
  pkg-config,
  php,
  libx11,
  udev,
  freetype,
  gtk3,
  xdotool,
}:

let
  wdl = fetchFromGitHub {
    owner = "justinfrankel";
    repo = "WDL";
    rev = "f1dc4d9e31d54f53b3183a9737303e4ca7369f24";
    hash = "sha256-IJhqI9hgnXbil8c38SEPK5Y81oGZZuTBuQNrOMf6UKA=";
  };

  helgoboss-learn = fetchFromGitHub {
    owner = "helgoboss";
    repo = "helgoboss-learn";
    rev = "fb94504104dafe7e55d7cfac0cfee42619f7b4f9";
    hash = "sha256-mKoFbh1xCjssCZ53gfyyQPucBW1F0V/MzCjZmjeu60o=";
  };

  eel2 = stdenv.mkDerivation {
    pname = "eel2";
    version = "0-unstable-2024-07-16";

    src = "${wdl}/WDL";

    preBuild = "cd eel2";

    nativeBuildInputs = [
      pkg-config
      nasm
    ];

    buildInputs = [
      freetype
      gtk3
    ];

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reaper-realearn-extension";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "helgoboss";
    repo = "helgobox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bC1XfAuxD+tJZpBf9lDY1JqjJnrUOH3OMmIP3oRB06k=";
  };

  # Can't fetch all submodules, adding some manually
  preBuild = ''
    pushd main/lib
      rm -r WDL
      cp -r ${wdl} WDL

      # TODO: helgobox/main/build.rs should deal with compiling this,
      # but it does not for some reason :/
      chmod -R u+w WDL
      cp ${eel2}/asm-nseel-x64-sse.o WDL/WDL/eel2

      rm -r helgoboss-learn
      ln -s ${helgoboss-learn} helgoboss-learn
    popd

    rm -r playtime-clip-engine
    ln -s playtime-clip-engine-placeholder playtime-clip-engine
  '';

  nativeBuildInputs = [
    pkg-config
    php
  ];

  buildInputs = [
    libx11
    udev
    xdotool
  ];

  cargoHash = "sha256-ElpYnOR5m55KBIx8UuEJWoFbrdkRj7P+BhibzomSwkk=";

  meta = {
    description = "Versatile Controller Integration for REAPER";
    homepage = "https://www.helgoboss.org/projects/realearn";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
