{
  pkgs ? import <nixpkgs> {}
}:

pkgs.stdenv.mkDerivation rec {
  pname = "doas-keepenv";
  version = "%-!";

  src = fetchTarball {
    url = "https://github.com/stas-badzi/doas-keepenv/archive/refs/tags/%.tar.gz";
    sha256 = "sha256:15xh3dgw78v6mfgkqv6mphpw0bxxbg7jqrpkb4y5151a9xjc9962";
  };

  buildInputs = [
    pkgs.bash
    pkgs.coreutils
    pkgs.doas
  ];

  nativeBuildInputs = [
    pkgs.coreutils
    pkgs.makeWrapper
  ];

  configurePhase = ''
  
  '';

  buildPhase = ''
    
  '';

  installPhase = ''
    mkdir -p $out/bin/ $out/share/licenses/doas-keepenv $out/share/doc/doas-keepenv
    install -m 755 doas-keepenv $out/bin
    install -Dm644 LICENSE $out/share/licenses/doas-keepenv
    install -Dm644 README.md $out/share/doc/doas-keepenv
    wrapProgram $out/bin/doas-keepenv --prefix PATH : ${pkgs.lib.makeBinPath [
      pkgs.coreutils
    ]}
    # don't add doas to path, 'cause we need the wrapper to funtion
  '';

  meta = with pkgs.lib; {
    description = "A bash script for running the doas command with keeping environment variables";
    homepage = "https://github.com/stas-badzi/doas-keepenv";
    mainProgram = "doas-keepenv";
    license = pkgs.lib.licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ stasbadzi ];
    platforms = pkgs.lib.platforms.linux;
  };
}
