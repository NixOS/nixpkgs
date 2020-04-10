{ stdenv, pkgs }:
(import ./composition.nix {
  inherit pkgs;
  inherit (stdenv.hostPlatform) system;
})."package".overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ pkgs.makeWrapper pkgs.lumo ];
  postInstall = ''
    # remove symlink to node_modules/.bin
    rm $out/bin
    mkdir $out/bin

    # link to lumo executable
    patchShebangs $out/lib/node_modules/.bin/mastodon-bot

    # make sure the node modules are available to lumo
    makeWrapper $out/lib/node_modules/.bin/mastodon-bot $out/bin/mastodon-bot --set NODE_PATH $out/lib/node_modules/mastodon-bot/node_modules
  '';
  meta = with stdenv.lib; {
    description = "A bot for mirroring Twitter/Tumblr accounts and RSS feeds on Mastodon";
    homepage = "https://mastodon.social/@newsbot";
    license = licenses.mit;
    maintainers = [ maintainers.raboof ];
    platforms = platforms.all;
  };
})
