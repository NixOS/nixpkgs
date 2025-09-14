{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pandoc,
}:

buildGoModule rec {
  pname = "didder";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "makew0rld";
    repo = "didder";
    rev = "v${version}";
    hash = "sha256-wYAudEyOLxbNfk4M720absGkuWXcaBPyBAcmBNBaaWU=";
  };

  vendorHash = "sha256-UD90N3nE3H9GSdVhGt1zfCk8BhPaToKGu4i0zP0Lb3Q=";

  nativeBuildInputs = [ pandoc ];

  postBuild = ''
    make man
  '';

  postInstall = ''
    mkdir -p $out/share/man/man1
    gzip -c didder.1 > $out/share/man/man1/didder.1.gz
  '';

  meta = src.meta // {
    description = "Extensive, fast, and accurate command-line image dithering tool";
    license = lib.licenses.gpl3;
    mainProgram = "didder";
  };
}
