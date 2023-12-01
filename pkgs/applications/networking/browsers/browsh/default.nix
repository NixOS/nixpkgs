{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

let
  version = "1.8.2";

  # TODO: must build the extension instead of downloading it. But since it's
  # literally an asset that is indifferent regardless of the platform, this
  # might be just enough.
  webext = fetchurl {
    url = "https://github.com/browsh-org/browsh/releases/download/v${version}/browsh-${version}.xpi";
    hash = "sha256-04rLyQt8co3Z7UJnDJmj++E4n7of0Zh1jQ90Bfwnx5A=";
  };

in

buildGoModule rec {
  inherit version;

  pname = "browsh";

  sourceRoot = "${src.name}/interfacer";

  src = fetchFromGitHub {
    owner = "browsh-org";
    repo = "browsh";
    rev = "v${version}";
    hash = "sha256-KbBVcNuERBL94LuRx872zpjQTzR6c5GalsBoNR52SuQ=";
  };

  vendorHash = "sha256-eCvV3UuM/JtCgMqvwvqWF3bpOmPSos5Pfhu6ETaS58c=";

  preBuild = ''
    cp "${webext}" src/browsh/browsh.xpi
  '';

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A fully-modern text-based browser, rendering to TTY and browsers";
    homepage = "https://www.brow.sh/";
    maintainers = with maintainers; [ kalbasit siraben ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
