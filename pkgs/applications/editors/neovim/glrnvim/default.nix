{ stdenv, rustPlatform, makeWrapper, alacritty, neovim }:

rustPlatform.buildRustPackage rec {
  pname = "glrnvim";
  version = "0.1.1";

  src = builtins.fetchTarball {
    url = "https://github.com/beeender/${pname}/archive/v${version}.tar.gz";
    sha256 = "11cp2vp9q9i9bhxv4s968m1gwsaj3wlj7gibxdk21wy72r5f6g6z";
  };

  cargoSha256 = "1kcbfbkbks0kcibynrdiwxym9gj0kanfblbs65wpys96q7axy53s";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/glrnvim \
      --prefix PATH : ${stdenv.lib.makeBinPath [alacritty neovim]}
  '';

  meta = with stdenv.lib; {
    description = "A GPU-accelerated neovim GUI";
    homepage = https://github.com/beeender/glrnvim;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.sgraf ];
  };
}
