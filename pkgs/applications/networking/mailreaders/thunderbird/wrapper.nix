# nixpkgs-update: no auto update
{
  lib,
  stdenv,
  wrapFirefox,
  gpgme,
  gnupg,
}:

browser: args:

(wrapFirefox browser (
  {
    libName = "thunderbird";
  }
  // args
))

.overrideAttrs
  (old: {
    # Keep update tools from treating the wrapper as the source package.
    pos = __curPos;

    # Thunderbird's native GPG support does not yet support smartcards.
    # The official upstream recommendation is to configure fall back to gnupg
    # using the Thunderbird config `mail.openpgp.allow_external_gnupg`
    # and GPG keys set up; instructions with pictures at:
    # https://anweshadas.in/how-to-use-yubikey-or-any-gpg-smartcard-in-thunderbird-78/
    # For that to work out of the box, it requires `gnupg` on PATH and
    # `gpgme` on the dynamic loader's search path; we do this below.
    # dyld ignores `LD_LIBRARY_PATH`, so Darwin needs `DYLD_FALLBACK_LIBRARY_PATH`.
    buildCommand = old.buildCommand + ''
      wrapProgram "$executablePath" \
        --prefix ${
          if stdenv.hostPlatform.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH"
        } ':' "${lib.makeLibraryPath [ gpgme ]}" \
        --prefix PATH ':' "${lib.makeBinPath [ gnupg ]}"
    '';
  })
