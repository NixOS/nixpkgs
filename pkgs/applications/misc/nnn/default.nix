{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, readline
, conf ? null, withIcons ? false, withNerdIcons ? false }:

# Mutually exclusive options
assert withIcons -> withNerdIcons == false;
assert withNerdIcons -> withIcons == false;

stdenv.mkDerivation rec {
  pname = "nnn";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fa7cmwrzn6kx87kms8i98p9azdlwyh2gnif29l340syl9hkr5qy";
  };

  configFile = lib.optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${configFile} src/nnn.h";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ readline ncurses ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ] ++ lib.optional withIcons [ "O_ICONS=1" ]
    ++ lib.optional withNerdIcons [ "O_NERD=1" ];

  # shell completions
  postInstall = ''
    install -Dm555 misc/auto-completion/bash/nnn-completion.bash $out/share/bash-completion/completions/nnn.bash
    install -Dm555 misc/auto-completion/zsh/_nnn -t $out/share/zsh/site-functions
    install -Dm555 misc/auto-completion/fish/nnn.fish -t $out/share/fish/vendor_completions.d
  '';

  meta = with lib; {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau Br1ght0ne ];
  };
}
