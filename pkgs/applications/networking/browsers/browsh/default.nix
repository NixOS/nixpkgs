{ stdenv, buildGoPackage, fetchurl, fetchFromGitHub, go-bindata }:

let
  version = "1.4.10";

  # TODO: must build the extension instead of downloading it. But since it's
  # literally an asset that is indifferent regardless of the platform, this
  # might be just enough.
  webext = fetchurl {
    url = "https://github.com/browsh-org/browsh/releases/download/v${version}/browsh-${version}-an.fx.xpi";
    sha256 = "0rgwzv1qahqy52q7zz4dklnwx7w4x3gj92ka8n0ypgf9fjjnmqas";
  };

in buildGoPackage rec {
  inherit version;

  name = "browsh-${version}";

  goPackagePath = "browsh";

  src = fetchFromGitHub {
    owner = "browsh-org";
    repo = "browsh";
    rev = "v${version}";
    sha256 = "0lvb20zziknlbgy509ccpvlc21sqjc53xar26blmb6sdl6yqkj0w";
  };

  buildInputs = [ go-bindata ];

  # embed the web extension in a go file and place it where it's supposed to
  # be. See
  # https://github.com/browsh-org/browsh/blob/9abc3aaa3f575ca6ec9a483408d9fdfcf76300fa/interfacer/contrib/xpi2bin.sh
  preBuild = ''
    xpiprefix="$(mktemp -d)"
    cp "${webext}" "$xpiprefix/browsh.xpi"
    go-bindata \
      -prefix "$xpiprefix" \
      -pkg browsh \
      -o "$NIX_BUILD_TOP/go/src/${goPackagePath}/interfacer/src/browsh/webextension.go" \
      "$xpiprefix/browsh.xpi"

    sed \
      -e 's:Asset("/browsh.xpi"):Asset("browsh.xpi"):g' \
      -i "$NIX_BUILD_TOP/go/src/${goPackagePath}/interfacer/src/browsh/firefox.go"
  '';

  postBuild = ''
    mv "$NIX_BUILD_TOP/go/bin/src" "$NIX_BUILD_TOP/go/bin/browsh"
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A fully-modern text-based browser, rendering to TTY and browsers";
    homepage = https://www.brow.sh/;
    maintainers = [ maintainers.kalbasit ];
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
