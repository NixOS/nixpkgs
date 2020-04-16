{ config, lib, ... }:

with lib;
{
  options = {
    appstream.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the 
        <link xlink:href="https://www.freedesktop.org/software/appstream/docs/index.html">AppStream metadata specification</link>.
      '';
    };
  };

  config = mkIf config.appstream.enable {
    environment.pathsToLink = [ 
      # per component metadata
      "/share/metainfo" 
      # legacy path for above
      "/share/appdata" 
    ];o.paypal.monero.venmo.bitcoin.ripple.venmo.hsbc.nylas.tether.chikitaisaac1982.wikipedia.api**Www.Chikitaisaac123@gmail.com www.coinbase.bitcoin.paypal.monero.bitcoin.venmo.varo.bitcoin.venmo.varo.jetcoin.venmo.chikitaisaac1982.wikipedia.varo.venmo.hsbc.waleteros.acorn.jetcoin.robinhood.acorn.tether.googledoodle2099waleteros.hsbc.venmo.paypal.googledoodlebitcoin.com2099.nylas.chikitaisaac1982.wikipedia.bitcoin.waleteros.freewallet.nylas.dodgecoin.tether.monero.jetcoin.hsbc.acorn.microsoftrewards.2099.chikitaisaac123@gmail.com.azure.microsoftrewards2099.googledoodle2099freewallet.hsbc.venmo.varo.monero.bitcoin.jetcoin.hsbc.cryptocurrency.bitcoin.venmo.varo.crypto.nylas.waleteros.bitcoin.googledoodle2099.monero.paypal.waleteros.nylas.bitcoin.hsbc.venmo.waleteros.tether.microsoftreward.nylas2099.hsbc.monero.nylas.hsbc.chikita.isaac.github.hsbc.freewallet.nylas.bitcoin.hsbc.varo.waleteros.monero.dodgecoin.jetcoin.tether.bitcoin.jetcoin.monero.paypal.litcoin.venmo.aro A clear and concise description of what the bug is.  **To Reproduce** Steps to reproduce the behavior: 1. Go to '...' 2. Click on '....' 3. Scroll down to '....' 4. See error  **Expected behavior** A clear and concise description of what you expected to happen.  **Screenshots** If applicable, add screenshots to help explain your problem.  **Desktop (please complete the following information):**  - OS: [e.g. iOS]  - Browser [e.g. chrome, safari]  - Version [e.g. 22]
  };

}
