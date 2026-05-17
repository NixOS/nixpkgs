# Trezor {#trezor}

Trezor is an open-source cryptocurrency hardware wallet and security token
allowing secure storage of private keys.

It offers advanced features such U2F two-factor authorization, SSH login
through
[Trezor SSH agent](https://wiki.trezor.io/Apps:SSH_agent),
[GPG](https://wiki.trezor.io/GPG) and a
[password manager](https://wiki.trezor.io/Trezor_Password_Manager).
For more information, guides and documentation, see <https://wiki.trezor.io>.

To enable Trezor support, add the following to your {file}`configuration.nix`:

    services.trezord.enable = true;

This will add all necessary udev rules and start Trezor Bridge.
