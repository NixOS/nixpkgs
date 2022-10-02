{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

let
  version = "1.8.0";

  # TODO: must build the extension instead of downloading it. But since it's
  # literally an asset that is indifferent regardless of the platform, this
  # might be just enough.
  webext = fetchurl {
    url = "https://github.com/browsh-org/browsh/releases/download/v${version}/browsh-${version}.xpi";
    sha256 = "sha256-12xWbf4ngYHWLKV9yyxyi0Ny/zHSj2o7Icats+Ef+pA=";
  };

in

buildGoModule rec {
  inherit version;

  pname = "browsh";

  sourceRoot = "source/interfacer";

  src = fetchFromGitHub {
    owner = "browsh-org";
    repo = "browsh";
    rev = "v${version}";
    sha256 = "sha256-/tH1w6qi+rimsqtk8Y8AYljU3X4vbmoDtV07piWSBdw=";
  };

  vendorSha256 = "sha256-eCvV3UuM/JtCgMqvwvqWF3bpOmPSos5Pfhu6ETaS58c=";

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
