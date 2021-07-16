{ wrapFirefox }:

args:

wrapFirefox ({
  firefoxLibName = "thunderbird";

  # TODO gnupg, gpgme
} // args)
