{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "apg";
  version = "unstable-2015-01-29";

  src = fetchFromGitHub {
    owner = "wilx";
    repo = "apg";
    rev = "7ecdbac79156c8864fa3ff8d61e9f1eb264e56c2";
    sha256 = "sha256-+7TrJACdm/i/pc0dsp8edEIOjx8cip+x0Qc2gONajSE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openssl ];

  meta = {
    description = "Tools for random password generation";
    longDescription = ''
       APG (Automated Password Generator) is the tool set for random
       password generation.

       Standalone version

         Generates some random words of required type and prints them
         to standard output.

       Network version

         APG server: When client's request is arrived generates some
         random words of predefined type and send them to client over
         the network (according to RFC0972).

         APG client: Sends the password generation request to the APG
         server, wait for generated Passwords arrival and then prints
         them to the standard output.

      Advantages

        * Built-in ANSI X9.17 RNG (Random Number Generator) (CAST/SHA1)
        * Built-in password quality checking system (it has support for
          Bloom filter for faster access)
        * Two Password Generation Algorithms:
            1. Pronounceable Password Generation Algorithm (according to
               NIST FIPS 181)
            2. Random Character Password Generation Algorithm with 35
               configurable modes of operation
        * Configurable password length parameters
        * Configurable amount of generated passwords
        * Ability to initialize RNG with user string
        * Support for /dev/random
        * Ability to crypt() generated passwords and print them as
          additional output
        * Special parameters to use APG in script
        * Ability to log password generation requests for network version
        * Ability to control APG service access using tcpd
        * Ability to use password generation service from any type of box
          (Mac, WinXX, etc.) that connected to network
        * Ability to enforce remote users to use only allowed type of
          password generation
    '';
    homepage = "https://github.com/wilx/apg";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
