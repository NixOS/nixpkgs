{ bat, crystal, fd, fzf, fetchFromGitHub, fetchurl, jq, kakoune, lib, stdenv }:
let
  icon = fetchurl {
    url = "https://github.com/mawww/kakoune/raw/master/doc/kakoune_logo.svg";
    sha256 = "1x9gdrnrqgzvr1ixr6s8ff6cvz01yp2xdh5ad6nbh6p2d094h617";
    name = "kakoune.svg";
  };

in crystal.buildCrystalPackage rec {
  pname = "kakoune-cr";
  version = "unstable-2021-04-30";

  propagatedUserEnvPkgs = [ bat fd fzf jq ];
  doInstallCheck = false;

  src = fetchFromGitHub {
    repo = "kakoune.cr";
    owner = "alexherbo2";
    rev = "c0bfd9e76a972359098af9f1957ab681e3a54318";
    sha256 = "sha256-acqC5RT9duI/zmE5Nk7COI2sQzvi0lkmLJ8orvBOL7c=";
  };

  crystalBinaries.kcr.src = "src/cli.cr";

  format = "shards";
  shardsFile = ./shards.nix;
  lockFile = ./shard.lock;

  preConfigure = ''
    substituteInPlace src/version.cr --replace \
    '`git describe --tags --always`' \
    '"${version}"'
  '';

  postInstall = ''
    install -Dm555 share/kcr/commands/*/kcr-* -t $out/bin
    install -Dm444 ${icon} -t $out/share/icons/hicolor/scalable/apps/${icon.name}
    install -Dm444 share/kcr/applications/kakoune.desktop -t $out/share/applications
    cp -r share/kcr $out/share/
  '';

  meta = with lib; {
    homepage = "https://github.com/alexherbo2/kakoune.cr";
    description = "A command-line tool for Kakoune";
    license = licenses.unlicense;
    maintainers = with maintainers; [ loewenheim ];
    platforms = platforms.unix;
  };
}
