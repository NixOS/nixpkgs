{ stdenv, fetchFromGitHub, pandoc }:

stdenv.mkDerivation rec {
  name = "git-dit-${version}";
  version = "0.1.0";

  buildInputs = [ pandoc ];

  src = fetchFromGitHub {
    owner = "neithernut";
    repo = "git-dit";
    rev = "v${version}";
    sha256 = "1rvp2dhnb8yqrracvfpvf8z1vz4fs0rii18hhrskr6n1sfd7x9kd";
  };

  # the Makefile doesn’t work, we emulate it below
  dontBuild = true;

  postPatch = ''
    # resolve binaries to the right path
    sed -e "s|exec git-dit-|exec $out/bin/git-dit-|" -i git-dit

    # we change every git dit command to the local subcommand path
    # (git dit foo -> /nix/store/…-git-dit/bin/git-dit-foo)
    for script in git-dit-*; do
      sed -e "s|git dit |$out/bin/git-dit-|g" -i "$script"
    done
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    # from the Makefile
    ${stdenv.lib.getBin pandoc}/bin/pandoc -s -t man git-dit.1.md \
                                           -o $out/share/man/man1/git-dit.1
    cp git-dit* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Decentralized Issue Tracking for git";
    inherit (src) homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ profpatsch matthiasbeyer ];
  };


}
