{
  lib,
  bundlerEnv,
  ruby,
  buildRubyGem,
  bundlerUpdateScript,
  mplayer,
  imagemagick,
}:
let
  pname = "lolcommits";
  version = "0.17.2";

  deps = bundlerEnv rec {
    inherit ruby version;
    name = "${pname}-deps-${version}";
    gemdir = ./.;
  };

  path = lib.makeBinPath [
    mplayer
    imagemagick
  ];
in
buildRubyGem rec {
  inherit pname version ruby;
  gemName = pname;
  source.sha256 = "sha256-Kwp8wZUn+cfrwEHRt11cNrfhjwfWJQbjw2ba9arIgLY=";

  propagatedBuildInputs = [ deps ];

  preFixup = ''
    wrapProgram $out/bin/lolcommits --prefix PATH : ${path}
  '';

  passthru.updateScript = bundlerUpdateScript "lolcommits";

  meta = {
    description = "Git-based selfies for software developers";
    homepage = "https://lolcommits.github.io/";
    license = with lib.licenses; [ lgpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix;
    mainProgram = "lolcommits";
  };
}
