{ lib, stdenv, fetchFromGitHub, pkg-config, makeWrapper, ncurses, readline
, archivemount, atool, fzf, libarchive, rclone, sshfs, unzip, vlock
, conf ? null, withIcons ? false, withNerdIcons ? false }:

# Mutually exclusive options
assert withIcons -> withNerdIcons == false;
assert withNerdIcons -> withIcons == false;

stdenv.mkDerivation rec {
  pname = "nnn";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cbxgss9j0bvsp3czjx1kpm9id7c5xxmjfnvjyk3pfd69ygif2kl";
  };

  configFile = lib.optionalString (conf != null) (builtins.toFile "nnn.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${configFile} src/nnn.h";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ readline ncurses ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optional withIcons [ "O_ICONS=1" ]
    ++ lib.optional withNerdIcons [ "O_NERD=1" ];

  # shell completions
  postInstall = ''
    install -Dm555 misc/auto-completion/bash/nnn-completion.bash $out/share/bash-completion/completions/nnn.bash
    install -Dm555 misc/auto-completion/zsh/_nnn -t $out/share/zsh/site-functions
    install -Dm555 misc/auto-completion/fish/nnn.fish -t $out/share/fish/vendor_completions.d

    wrapProgram $out/bin/nnn \
      --prefix PATH : ${lib.makeBinPath [ archivemount atool fzf libarchive rclone sshfs unzip vlock ]}
  '';

  meta = with lib; {
    description = "Small ncurses-based file browser forked from noice";
    homepage = "https://github.com/jarun/nnn";
    changelog = "https://github.com/jarun/nnn/blob/v${version}/CHANGELOG";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau Br1ght0ne ];
  };
}
