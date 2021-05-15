{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  pname = "pifi";

  version = (import ./gemset.nix).pifi.version;
  inherit ruby;
  # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
  gemdir = ./.;

  meta = with lib; {
    description = "MPD web client to listen to radio, written in React and Sinatra";
    homepage = "https://github.com/rccavalcanti/pifi-radio";
    license = with licenses; gpl3Only;
    maintainers = with maintainers; [ kmein ];
    platforms = platforms.unix;
  };
}
