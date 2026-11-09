{
  lib,
  buildRubyGem,
  bundlerEnv,
  ruby,
  poppler-utils,
}:
let
  deps = bundlerEnv rec {
    name = "anystyle-cli-${version}";
    source.sha256 = lib.fakeSha256;
    version = "1.5.0";
    inherit ruby;
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) {
      anystyle.source = {
        remotes = [ "https://rubygems.org" ];
        sha256 = "C/OrU7guHzHdY80upEXRfhWmUYDxpI54NIvIjKv0znw=";
        type = "gem";
      };
    };
  };
in
buildRubyGem rec {
  inherit ruby;
  gemName = "anystyle-cli";
  pname = gemName;
  version = "1.5.0";
  source.sha256 = "Bkk00PBk/6noCXgAbr1XUcdBq5vpdeL0ES02eeNA594=";

  propagatedBuildInputs = [ deps ];

  preFixup = ''
    wrapProgram $out/bin/anystyle --prefix PATH : ${poppler-utils}/bin
  '';

  meta = {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage = "https://anystyle.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      aschleck
    ];
    mainProgram = "anystyle";
    platforms = lib.platforms.unix;
  };
}
