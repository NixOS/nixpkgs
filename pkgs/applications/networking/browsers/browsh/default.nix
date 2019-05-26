{ stdenv, buildGoPackage, fetchurl, fetchFromGitHub, go-bindata }:

let
  version = "1.5.0";

  # TODO: must build the extension instead of downloading it. But since it's
  # literally an asset that is indifferent regardless of the platform, this
  # might be just enough.
  webext = fetchurl {
    url = "https://github.com/browsh-org/browsh/releases/download/v${version}/browsh-${version}-an.fx.xpi";
    sha256 = "063m6rcdyf2zcrswkm56k8h3w15124bw5iykklzm60q5jk4ywn3f";
  };

in buildGoPackage rec {
  inherit version;

  name = "browsh-${version}";

  goPackagePath = "browsh";

  # further go package dependencies are defined in deps.nix, see line below.
  src = fetchFromGitHub {
    owner = "browsh-org";
    repo = "browsh";
    rev = "v${version}";
    sha256 = "14addyb1zdk1b9mizfxdagyzlkd9nf5gawnbrs44j5a3ggnl14ln";
  };

  buildInputs = [ go-bindata ];

  # embed the web extension in a go file and place it where it's supposed to
  # be. See
  # https://github.com/browsh-org/browsh/blob/v1.5.0/interfacer/contrib/xpi2bin.sh
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
