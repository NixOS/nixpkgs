{
  stdenv,
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  makeWrapper,
  groff,
  callPackage,
}:
let
  rubyEnv = bundlerEnv {
    name = "ronn-gems";
    gemdir = ./.;
  };
in
stdenv.mkDerivation {
  pname = "ronn";
  version = rubyEnv.gems.ronn-ng.version;

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/ronn $out/bin/ronn \
      --set PATH ${groff}/bin

    runHook postInstall
  '';

  passthru.updateScript = bundlerUpdateScript "ronn";

  passthru.tests.reproducible-html-manpage = callPackage ./test-reproducible-html.nix { };

  meta = with lib; {
    description = "Markdown-based tool for building manpages";
    mainProgram = "ronn";
    homepage = "https://github.com/apjanke/ronn-ng";
    license = licenses.mit;
    maintainers = with maintainers; [
      zimbatm
      nicknovitski
    ];
    platforms = rubyEnv.ruby.meta.platforms;
  };
}
