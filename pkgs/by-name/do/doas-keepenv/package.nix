{
  stdenv,
  lib,
  coreutils,
  doas,
  makeWrapper,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "doas-keepenv";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/stas-badzi/doas-keepenv/archive/refs/tags/1.0.tar.gz";
    sha256 = "sha256:15xh3dgw78v6mfgkqv6mphpw0bxxbg7jqrpkb4y5151a9xjc9962";
  };

  buildInputs = [
    doas
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildPhase = ''

  '';

  installPhase = ''
    mkdir -p $out/bin/
    install -m 755 doas-keepenv $out/bin
    wrapProgram $out/bin/doas-keepenv --prefix PATH : "${
      lib.makeBinPath [
        coreutils
        doas
      ]
    }:/run/wrappers/bin/doas"
  '';

  meta = {
    description = "A bash script for running the doas command while keeping environment variables";
    homepage = "https://github.com/stas-badzi/doas-keepenv";
    mainProgram = "doas-keepenv";
    license = lib.licenses.mit;
    #maintainers = with lib.maintainers; [ stasbadzi ];
    platforms = lib.platforms.linux;
  };
}
