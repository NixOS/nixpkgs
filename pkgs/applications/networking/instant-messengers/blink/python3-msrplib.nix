{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, application, ag-gnutls, eventlib
, twisted, zope_interface, ... }:

buildPythonPackage rec {
  pname = "python3-msrplib";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-msrplib";
    rev = "5bd069620d436d5a65e1c369e43cc6b88857fb9e";
    sha256 = "sha256-z0gF/oQW/h3qiCL1cFWBPK7JYzLCNAD7/dg7HfY4rig=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ application ag-gnutls eventlib twisted zope_interface ];

  buildInputs = [ ];

  meta = with lib; {
    description = "Message Session Relay Protocol (MSRP)";
    homepage = "https://github.com/AGProjects/python3-msrplib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      Message Session Relay Protocol (MSRP) is a protocol for transmitting a
      series of related instant messages in the context of a session. Message
      sessions are treated like any other media stream when set up via a
      rendezvous or session creation protocol such as the Session Initiation
      Protocol (SIP).

      A series of related instant messages between two or more parties can be
      viewed as part of a "message session", that is, a conversational exchange of
      messages with a definite beginning and end. This is in contrast to
      individual messages each sent independently. Messaging schemes that track
      only individual messages can be described as "page-mode" messaging, whereas
      messaging that is part of a "session" with a definite start and end is
      called "session-mode" messaging.

      Page-mode messaging is enabled in SIP via the SIP MESSAGE method, as defined
      in RFC 3428. Session-mode messaging has a number of benefits over page-mode
      messaging, however, such as explicit rendezvous, tighter integration with
      other media-types, direct client-to-client operation, and brokered privacy
      and security.
    '';
  };
}
