{
  stdenv,
  lib,
  bash,
  coreutils,
  doas,
  makeWrapper,
  fetchurl
}:

stdenv.mkDerivation {
  pname = "doas-keepenv";
  version = "1.0-1";

  src = fetchurl {
    url = "https://github.com/stas-badzi/doas-keepenv/archive/refs/tags/1.0.tar.gz";
    sha256 = "sha256:15xh3dgw78v6mfgkqv6mphpw0bxxbg7jqrpkb4y5151a9xjc9962";
  };

  buildInputs = [
    bash
    coreutils
    doas
  ];

  nativeBuildInputs = [
    coreutils
    makeWrapper
  ];

  buildPhase = ''

  '';

  installPhase = ''
    mkdir -p $out/bin/ $out/share/licenses/doas-keepenv $out/share/doc/doas-keepenv
    install -m 755 doas-keepenv $out/bin
    install -Dm644 LICENSE $out/share/licenses/doas-keepenv
    install -Dm644 README.md $out/share/doc/doas-keepenv
    wrapProgram $out/bin/doas-keepenv --prefix PATH : ${
      lib.makeBinPath [
        coreutils
      ]
    }
    # don't add doas to path, 'cause we need the wrapper to funtion
  '';

  meta = {
    description = "A bash script for running the doas command with keeping environment variables";
    homepage = "https://github.com/stas-badzi/doas-keepenv";
    mainProgram = "doas-keepenv";
    license = lib.licenses.mit;
    #maintainers = with lib.maintainers; [ stasbadzi ];
    platforms = lib.platforms.linux;
  };
}
