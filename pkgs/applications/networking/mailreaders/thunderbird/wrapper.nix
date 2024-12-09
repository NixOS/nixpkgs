{ lib, wrapFirefox, gpgme, gnupg }:

browser:
args:

(wrapFirefox browser ({
  libName = "thunderbird";
} // args))

.overrideAttrs (old: {
  # Thunderbird's native GPG support does not yet support smartcards.
  # The official upstream recommendation is to configure fall back to gnupg
  # using the Thunderbird config `mail.openpgp.allow_external_gnupg`
  # and GPG keys set up; instructions with pictures at:
  # https://anweshadas.in/how-to-use-yubikey-or-any-gpg-smartcard-in-thunderbird-78/
  # For that to work out of the box, it requires `gnupg` on PATH and
  # `gpgme` in `LD_LIBRARY_PATH`; we do this below.
  buildCommand = old.buildCommand + ''
    wrapProgram $out/bin/${browser.binaryName} \
      --prefix LD_LIBRARY_PATH ':' "${lib.makeLibraryPath [ gpgme ]}" \
      --prefix PATH ':' "${lib.makeBinPath [ gnupg ]}"
  '';
})
