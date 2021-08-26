{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, zope_interface, application, cryptography,  gmpy2, ... }:

buildPythonPackage rec {
  pname = "python3-otr";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-otr";
    rev = "${version}";
    sha256 = "sha256-XsJQIRZj04TkoWIddOc0evXwNFP/IYF/z/nO7mC0aVY=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ application zope_interface cryptography gmpy2 ];

  patches = [ ./python3-otr-dep-name.patch ]; # remove if upstream PR accepted

  dontUseSetuptoolsCheck = true; # some tests fail with "TypeError: can't concat str to bytes"

  pythonImportsCheck = [ "otr" ];

  meta = with lib; {
    description = "Off-The-Record Messaging protocol implemented in pure python";
    homepage = "https://github.com/AGProjects/python3-otr";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      Off-The-Record Messaging (OTR) is a cryptographic protocol that provides
      encryption for instant messaging conversations. OTR uses a combination of
      AES symmetric-key algorithm with 128 bits key length, the Diffie-Hellman
      key exchange with 1536 bits group size, and the SHA-1/SHA-256 hash functions.

      Features of the OTR protocol:

      1. End-to-end encryption: No one else can read your messages.
      2. Authentication: The correspondent's identity can be verified.
      3. Deniability: The messages you send do not have digital signatures that can
         be checked by a third party. Anyone can forge messages after a conversation
         to make them look like they came from you, however during the conversation
         your correspondent is assured that the messages he sees coming from you are
         authentic and unmodified.
      4. Perfect forward secrecy: If you lose control of your private keys, you are
         assured that no previous conversation is compromised.

      This package implements the version 2 and 3 of the OTR protocol.
      For more details see https://otr.cypherpunks.ca/
    '';
  };
}
